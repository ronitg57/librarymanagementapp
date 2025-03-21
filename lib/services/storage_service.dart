// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/loan.dart';

class StorageService {
  static const String USERS_KEY = 'users';
  static const String BOOKS_KEY = 'books';
  static const String LOANS_KEY = 'loans';
  static final StorageService _instance = StorageService._internal();
  
  factory StorageService() => _instance;
  
  StorageService._internal();

  Future<void> initializeStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(USERS_KEY)) {
      // Create default admin user
      final defaultAdmin = {
        'id': '1',
        'name': 'Admin',
        'email': 'admin@library.com',
        'password': 'admin123', // In real app, this should be hashed
        'role': 'admin'
      };
      await prefs.setString(USERS_KEY, jsonEncode([defaultAdmin]));
    }
    if (!prefs.containsKey(BOOKS_KEY)) {
      await prefs.setString(BOOKS_KEY, jsonEncode([]));
    }
    if (!prefs.containsKey(LOANS_KEY)) {
      await prefs.setString(LOANS_KEY, jsonEncode([]));
    }
  }

  // User related methods
  Future<bool> authenticateUser(String email, String password) async {
    final users = await getUsers();
    return users.any((user) => 
      user['email'] == email && user['password'] == password
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final users = await getUsers();
    try {
      return users.firstWhere(
        (user) => user['email'] == email,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(USERS_KEY) ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(usersString));
  }

  Future<void> addUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    user['id'] = (users.length + 1).toString();
    users.add(user);
    await prefs.setString(USERS_KEY, jsonEncode(users));
  }

  // Book related methods
  Future<List<Map<String, dynamic>>> getBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksString = prefs.getString(BOOKS_KEY) ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(booksString));
  }

  Future<void> addBook(Map<String, dynamic> book) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getBooks();
    book['id'] = (books.length + 1).toString();
    books.add(book);
    await prefs.setString(BOOKS_KEY, jsonEncode(books));
  }

  Future<void> updateBook(Map<String, dynamic> book) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getBooks();
    final index = books.indexWhere((b) => b['id'] == book['id']);
    if (index != -1) {
      books[index] = book;
      await prefs.setString(BOOKS_KEY, jsonEncode(books));
    }
  }

  // Loan related methods
  Future<List<Map<String, dynamic>>> getLoans() async {
    final prefs = await SharedPreferences.getInstance();
    final loansString = prefs.getString(LOANS_KEY) ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(loansString));
  }

  Future<void> addLoan(Map<String, dynamic> loan) async {
    final prefs = await SharedPreferences.getInstance();
    final loans = await getLoans();
    loan['id'] = (loans.length + 1).toString();
    loans.add(loan);
    await prefs.setString(LOANS_KEY, jsonEncode(loans));
  }
}