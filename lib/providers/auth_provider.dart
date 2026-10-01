import 'package:flutter/foundation.dart';

import '../models/auth_session.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;
  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _hasCheckedSession = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get hasCheckedSession => _hasCheckedSession;
  bool get isAuthenticated => _user != null && _token != null;
  String? get error => _error;

  Future<bool> restoreSession() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final session = await _authService.restoreSession();
      _applySession(session);
      return session != null;
    } finally {
      _hasCheckedSession = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String cellphone, required String password}) {
    return _run(() => _authService.login(cellphone: cellphone, password: password));
  }

  Future<bool> register({
    required String fullName,
    required String cellphone,
    required String email,
    required String password,
  }) {
    return _run(() => _authService.register(
          fullName: fullName,
          cellphone: cellphone,
          email: email,
          password: password,
        ));
  }

  Future<bool> _run(Future<AuthSession> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _applySession(await action());
      return true;
    } on ApiException catch (error) {
      _error = error.message;
      return false;
    } catch (_) {
      _error = 'Unable to connect to Shesha. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applySession(AuthSession? session) {
    _user = session?.user;
    _token = session?.token;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _token = null;
    _error = null;
    notifyListeners();
  }
}
