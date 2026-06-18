import 'dart:async';
import 'package:background_location_tracker/data/services/battery_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final batteryProvider = StateNotifierProvider<BatteryNotifier, int>((ref) {
  return BatteryNotifier();
});

class BatteryNotifier extends StateNotifier<int> {
  final _service = BatteryService();
  Timer? _timer;

  BatteryNotifier() : super(-1) {
    getBattery();
    // Update battery status periodically (every 30 seconds)
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => getBattery());
  }

  Future<void> getBattery() async {
    final level = await _service.getBatteryLevel();
    state = level;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
