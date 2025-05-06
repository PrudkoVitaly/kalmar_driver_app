import 'package:shared_preferences/shared_preferences.dart';
import '../services/fcm_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final SharedPreferences _prefs;
  late final FCMService fcmService;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    fcmService = FCMService(_prefs);
  }
} 