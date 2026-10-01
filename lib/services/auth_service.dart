import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_session.dart';
import '../models/user.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  static const String _baseUrl = 'https://api.gameshyft.co.za/auth';
  static const String _tokenKey = 'shesha_auth_token';

  Future<AuthSession> login({required String cellphone, required String password}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login.php'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'cellphone': _normaliseCellphone(cellphone),
        'password': password,
      }),
    ).timeout(const Duration(seconds: 20));

    final data = _decode(response);
    if (response.statusCode != 200 || data['success'] != true) {
      throw ApiException(data['message']?.toString() ?? 'Login failed.');
    }

    final token = data['token']?.toString() ?? '';
    final userData = data['user'];
    if (token.isEmpty || userData is! Map<String, dynamic>) {
      throw const ApiException('The server returned an invalid session.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    return AuthSession(token: token, user: User.fromJson(userData));
  }

  Future<AuthSession> register({
    required String fullName,
    required String cellphone,
    required String email,
    required String password,
  }) async {
    final normalisedCellphone = _normaliseCellphone(cellphone);
    final response = await http.post(
      Uri.parse('$_baseUrl/register.php'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'full_name': fullName.trim(),
        'cellphone': normalisedCellphone,
        'email': email.trim(),
        'password': password,
      }),
    ).timeout(const Duration(seconds: 20));

    final data = _decode(response);
    if (response.statusCode != 201 || data['success'] != true) {
      throw ApiException(data['message']?.toString() ?? 'Registration failed.');
    }

    return login(cellphone: normalisedCellphone, password: password);
  }

  Future<AuthSession?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/session.php'),
        headers: {..._jsonHeaders, 'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 20));

      final data = _decode(response);
      if (response.statusCode != 200 || data['success'] != true) {
        await prefs.remove(_tokenKey);
        return null;
      }

      final userData = data['user'];
      if (userData is! Map<String, dynamic>) {
        await prefs.remove(_tokenKey);
        return null;
      }
      return AuthSession(token: token, user: User.fromJson(userData));
    } catch (_) {
      // Keep the token during temporary network failure, but start signed out.
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token != null && token.isNotEmpty) {
      try {
        await http.post(
          Uri.parse('$_baseUrl/logout.php'),
          headers: {..._jsonHeaders, 'Authorization': 'Bearer $token'},
        ).timeout(const Duration(seconds: 10));
      } catch (_) {
        // Local sign-out must still succeed if the network is unavailable.
      }
    }

    await prefs.remove(_tokenKey);
  }

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw const ApiException('The server returned an unexpected response.');
    } on FormatException {
      throw ApiException('The API did not return JSON. HTTP ${response.statusCode}.');
    }
  }

  String _normaliseCellphone(String value) =>
      value.replaceAll(RegExp(r'[^0-9+]'), '');
}
