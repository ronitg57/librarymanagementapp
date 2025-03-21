// lib/services/auth_service.dart
import 'dart:convert';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

class AuthService {
  final _storage = FlutterSecureStorage();
  final _storageService = StorageService();

  Future<void> login(String email, String password) async {
    try {
      final isAuthenticated = await _storageService.authenticateUser(email, password);
      if (!isAuthenticated) {
        throw Exception('Invalid credentials');
      }

      final user = await _storageService.getUserByEmail(email);
      if (user == null || user.isEmpty) {
        throw Exception('User not found');
      }

      await _storage.write(key: 'user_id', value: user['id'].toString());
      await _storage.write(key: 'user_role', value: user['role']);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      final existingUser = await _storageService.getUserByEmail(email);
      if (existingUser != null && existingUser.isNotEmpty) {
        throw Exception('Email already registered');
      }

      await _storageService.addUser({
        'name': name,
        'email': email,
        'password': password,
        'role': 'user'
      });
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: 'user_role');
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }
  Future<User?> getCurrentUser() async {
    final userId = await getUserId();
    if (userId == null) return null;

    final users = await _storageService.getUsers();
    try {
      final userData = users.firstWhere((u) => u['id'] == userId);
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile(String userId, String name) async {
    final users = await _storageService.getUsers();
    final index = users.indexWhere((u) => u['id'] == userId);
    if (index != -1) {
      users[index]['name'] = name;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageService.USERS_KEY, jsonEncode(users));
    } else {
      throw Exception('User not found');
    }
  }
}