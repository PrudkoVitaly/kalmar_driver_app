import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kalmar_driver_app/core/di/injection_container.dart';

class AppInit {
  static Future<void> init() async {
    // Инициализация Firebase
    await Firebase.initializeApp();
    
    // Запрос разрешений для уведомлений
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // Инициализация контейнера зависимостей
    await InjectionContainer().init();
  }
} 