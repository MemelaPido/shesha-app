import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<bool> login({required String cellphone, required String password}) async {
    return _run(() => _authService.login(cellphone: cellphone, password: password));
  }

  Future<bool> register({
    required String fullName,
    required String cellphone,
    required String email,
    required String password,
  }) async {
    return _run(() => _authService.register(
          fullName: fullName,
          cellphone: cellphone,
          email: email,
          password: password,
        ));
  }

  Future<bool> _run(Future<User> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await action();
      return true;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
