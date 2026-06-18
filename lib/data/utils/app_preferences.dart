import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String trackingKey = "is_tracking";

  static Future<void> saveTracking(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(trackingKey, value);
  }

  static Future<bool> getTracking() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(trackingKey) ?? false;
  }
}
