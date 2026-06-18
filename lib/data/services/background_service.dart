import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import '../database/db_helper.dart';
import '../models/location_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class BackgroundTracker {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'location_tracker',
      'Location Tracker Service',
      description: 'Tracks location in background',
      importance: Importance.low,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundServiceStart,
        autoStart: false,
        isForegroundMode: true,

        notificationChannelId: 'location_tracker',

        initialNotificationTitle: 'Location Tracker',
        initialNotificationContent: 'Tracking location...',
        foregroundServiceNotificationId: 888,
      ),

      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: backgroundServiceStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    print("BACKGROUND SERVICE STARTED");

    await DBHelper.instance.database;

    service.on("stopService").listen((event) {
      service.stopSelf();
    });

    await _saveLocation(service);

    Timer.periodic(const Duration(seconds: 60), (timer) async {
      await _saveLocation(service);
    });
  }

  // @pragma('vm:entry-point')
  // static void onStart(ServiceInstance service) async {
  //   DartPluginRegistrant.ensureInitialized();

  //   service.on("stopService").listen((event) {
  //     service.stopSelf();
  //   });

  //   await _saveLocation(service);

  //   Timer.periodic(const Duration(seconds: 60), (_) async {
  //     await _saveLocation(service);
  //   });
  // }

  static Future<void> _saveLocation(ServiceInstance service) async {
    print("================================");
    print("SAVE LOCATION CALLED");
    print(DateTime.now());
    print("================================");

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      print("LAT=${position.latitude}, LNG=${position.longitude}");

      final locData = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: position.accuracy,
      );

      final id = await DBHelper.instance.insertLocation(locData);

      print("LOCATION SAVED ID: $id");

      service.invoke('onLocationUpdated', locData.toMap());
    } catch (e) {
      print("LOCATION ERROR: $e");
    }
  }
}

@pragma('vm:entry-point')
void backgroundServiceStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Location Tracker",
      content: "Tracking location in background",
    );
  }
  DartPluginRegistrant.ensureInitialized();

  print("BACKGROUND SERVICE STARTED");

  await DBHelper.instance.database;

  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  try {
    final position = await Geolocator.getCurrentPosition();

    print("LAT=${position.latitude}, LNG=${position.longitude}");

    final locData = LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      accuracy: position.accuracy,
    );

    await DBHelper.instance.insertLocation(locData);

    print("LOCATION SAVED");

    service.invoke("onLocationUpdated", locData.toMap());
  } catch (e) {
    print("LOCATION ERROR: $e");
  }

  Timer.periodic(const Duration(seconds: 60), (timer) async {
    try {
      final position = await Geolocator.getCurrentPosition();

      final locData = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: position.accuracy,
      );

      await DBHelper.instance.insertLocation(locData);

      print("LOCATION SAVED");

      service.invoke("onLocationUpdated", locData.toMap());
    } catch (e) {
      print("LOCATION ERROR: $e");
    }
  });
}
