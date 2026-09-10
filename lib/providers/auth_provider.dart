import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  /// Replace this with a real API call (e.g. POST /auth/login).
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    if (username.trim().isEmpty || password.isEmpty) {
      _error = 'Please enter both username and password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // TODO: hook up to real authentication backend.
    _isLoggedIn = true;
    _username = username.trim();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }
}
