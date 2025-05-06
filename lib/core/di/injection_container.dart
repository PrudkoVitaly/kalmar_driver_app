import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kalmar_driver_app/data/repositories/auth_repository_impl.dart';
import 'package:kalmar_driver_app/data/services/fcm_service.dart';
import 'package:kalmar_driver_app/domain/repositories/auth_repository.dart';
import 'package:kalmar_driver_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:kalmar_driver_app/presentation/bloc/auth/auth_event.dart';

/// Контейнер зависимостей приложения
class InjectionContainer {
  // Singleton
  static final InjectionContainer _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  // Core
  late final Dio _dio;
  late final FlutterSecureStorage _storage;

  // Services
  late final FCMService _fcmService;

  // Repositories
  late final AuthRepository _authRepository;

  // BLoCs
  late final AuthBloc _authBloc;

  /// Инициализация всех зависимостей
  Future<void> init() async {
    // Core
    _initCore();

    // Services
    _initServices();

    // Repositories
    _initRepositories();

    // BLoCs
    _initBlocs();
  }

  /// Инициализация базовых зависимостей
  void _initCore() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://164.92.207.93/api',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('Headers: ${options.headers}');
            print('Data: ${options.data}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            print('Data: ${response.data}');
            return handler.next(response);
          },
          onError: (error, handler) {
            print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            print('Error: ${error.response?.data}');
            if (error.response?.statusCode == 401) {
              _authBloc.add(AuthLogoutRequested());
            }
            return handler.next(error);
          },
        ),
      );

    _storage = const FlutterSecureStorage();
  }

  /// Инициализация сервисов
  void _initServices() {
    _fcmService = FCMService(FirebaseMessaging.instance);
  }

  /// Инициализация репозиториев
  void _initRepositories() {
    _authRepository = AuthRepositoryImpl(
      dio: _dio,
      storage: _storage,
      fcmService: _fcmService,
    );
  }

  /// Инициализация BLoC'ов
  void _initBlocs() {
    _authBloc = AuthBloc(authRepository: _authRepository);
  }

  // Геттеры для доступа к зависимостям
  AuthBloc get authBloc => _authBloc;
  AuthRepository get authRepository => _authRepository;
  FCMService get fcmService => _fcmService;
  Dio get dio => _dio;
  FlutterSecureStorage get storage => _storage;
} 