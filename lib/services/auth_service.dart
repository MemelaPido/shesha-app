import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  static const String _baseUrl = 'https://api.gameshyft.co.za/auth';

  Future<User> login({
    required String cellphone,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/login.php'),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'cellphone': _normaliseCellphone(cellphone),
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 20));

    final data = _decode(response);
    if (response.statusCode != 200 || data['success'] != true) {
      throw ApiException(data['message']?.toString() ?? 'Login failed.');
    }

    final userData = data['user'];
    if (userData is! Map<String, dynamic>) {
      throw const ApiException('The server returned an invalid user record.');
    }

    return User.fromJson(userData);
  }

  Future<User> register({
    required String fullName,
    required String cellphone,
    required String email,
    required String password,
  }) async {
    final normalisedCellphone = _normaliseCellphone(cellphone);
    final response = await http
        .post(
          Uri.parse('$_baseUrl/register.php'),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'full_name': fullName.trim(),
            'cellphone': normalisedCellphone,
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 20));

    final data = _decode(response);
    if (response.statusCode != 201 || data['success'] != true) {
      throw ApiException(data['message']?.toString() ?? 'Registration failed.');
    }

    // The register endpoint creates the account. Logging in immediately
    // returns the complete user object and keeps the Flutter flow unchanged.
    return login(cellphone: normalisedCellphone, password: password);
  }

  Future<void> logout() async {
    // Sprint 1B has no server session or token yet. Provider clears local state.
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw const ApiException('The server returned an unexpected response.');
    } on FormatException {
      throw ApiException(
        'The API did not return JSON. HTTP ${response.statusCode}.',
      );
    }
  }

  String _normaliseCellphone(String value) {
    return value.replaceAll(RegExp(r'[^0-9+]'), '');
  }
}
