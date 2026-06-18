import 'package:flutter/services.dart';

class BatteryService {
  static const _channel = MethodChannel('com.example.tracker/battery');

  Future<int> getBatteryLevel() async {
    try {
      final int result = await _channel.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (_) {
      return -1; // Error fallback
    }
  }
}
