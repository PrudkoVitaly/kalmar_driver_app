import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kalmar_driver_app/firebase_options.dart';
import '../di/service_locator.dart';

class AppInit {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await ServiceLocator().init();
    
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    
    // Инициализируем и сохраняем FCM токен
    await ServiceLocator().fcmService.initializeFCM();
  }
} 