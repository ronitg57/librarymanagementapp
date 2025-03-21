// lib/services/user_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class UserService {
  static const String USERS_KEY = 'users';

  Future<List<User>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(USERS_KEY) ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersString);
    return usersList.map((user) => User.fromJson(user)).toList();
  }

  Future<User?> getUserById(String id) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getAllUsers();
    final index = users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      users[index] = user;
      await prefs.setString(USERS_KEY, jsonEncode(users.map((u) => u.toJson()).toList()));
    }
  }
}