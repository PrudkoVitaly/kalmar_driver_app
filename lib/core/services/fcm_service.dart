import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMService {
  static const String _fcmTokenKey = 'fcm_token';
  final SharedPreferences _prefs;

  FCMService(this._prefs);

  Future<void> initializeFCM() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _prefs.setString(_fcmTokenKey, token);
      print("FCM Token saved: $token");
    }
  }

  String? getStoredFCMToken() {
    return _prefs.getString(_fcmTokenKey);
  }

  Future<void> refreshFCMToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _prefs.setString(_fcmTokenKey, token);
      print("FCM Token refreshed: $token");
    }
  }
} 