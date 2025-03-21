// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userRole;

  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _userRole;

  Future<void> checkAuthStatus() async {
    final storage = FlutterSecureStorage();
    final userRole = await storage.read(key: 'user_role');
    _isAuthenticated = userRole != null;
    _userRole = userRole;
    notifyListeners();
  }
}