import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kalmar_driver_app/features/auth/data/models/login_request.dart';
import 'package:kalmar_driver_app/features/auth/data/models/login_response.dart';
import 'package:kalmar_driver_app/features/auth/data/services/fcm_service.dart';
import 'package:kalmar_driver_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final FCMService _fcmService;
  static const String _tokenKey = 'auth_token';

  AuthRepositoryImpl({
    required Dio dio,
    required FlutterSecureStorage storage,
    required FCMService fcmService,
  })  : _dio = dio,
        _storage = storage,
        _fcmService = fcmService;

  @override
  Future<String> login(String username, String password) async {
    try {
      final fcmToken = await _fcmService.getToken() ?? '';
      
      final response = await _dio.post(
        'http://164.92.207.93/api/Auth/login',
        data: LoginRequest(
          username: username,
          password: password,
          fcmToken: fcmToken,
        ).toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      await _storage.write(key: _tokenKey, value: loginResponse.token);
      
      return loginResponse.token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Неверный логин или пароль');
      }
      throw Exception('Ошибка авторизации: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
} 