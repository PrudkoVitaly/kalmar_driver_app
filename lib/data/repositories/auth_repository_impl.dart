import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kalmar_driver_app/data/models/auth/login_request.dart';
import 'package:kalmar_driver_app/data/models/auth/login_response.dart';
import 'package:kalmar_driver_app/data/services/fcm_service.dart';
import 'package:kalmar_driver_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final FCMService _fcmService;

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
      final fcmToken = await _fcmService.getToken();
      
      final request = LoginRequest(
        username: username,
        password: password,
        fcmToken: fcmToken,
      );

      print('Login Request: ${request.toJson()}');

      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      print('Login Response: ${response.data}');

      final loginResponse = LoginResponse.fromJson(response.data!);
      await _storage.write(key: 'token', value: loginResponse.token);
      
      return loginResponse.token;
    } on DioException catch (e) {
      print('Login Error: ${e.response?.data}');
      throw Exception(e.response?.data?['message'] ?? 'Login failed');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
} 