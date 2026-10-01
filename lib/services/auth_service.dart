import '../models/user.dart';

class AuthService {
  Future<User> login({required String cellphone, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return User(
      id: 1,
      fullName: 'Kabelo Mokoena',
      cellphone: cellphone,
      email: 'kabelo@example.com',
    );
  }

  Future<User> register({
    required String fullName,
    required String cellphone,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return User(id: 1, fullName: fullName, cellphone: cellphone, email: email);
  }

  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
