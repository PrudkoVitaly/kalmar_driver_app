import 'package:kalmar_driver_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login(String username, String password) async {
    // TODO: Реализовать реальную авторизацию
    return 'dummy_token';
  }

  @override
  Future<void> logout() async {
    // TODO: Реализовать реальный выход
  }
} 