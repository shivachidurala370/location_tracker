import 'package:background_location_tracker/data/database/db_helper.dart';
import 'package:background_location_tracker/data/models/location_model.dart';
import 'package:background_location_tracker/data/utils/app_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackingState {
  final bool isTracking;
  final List<LocationModel> history;

  TrackingState({required this.isTracking, required this.history});

  TrackingState copyWith({bool? isTracking, List<LocationModel>? history}) {
    return TrackingState(
      isTracking: isTracking ?? this.isTracking,
      history: history ?? this.history,
    );
  }
}

class TrackingViewModel extends StateNotifier<TrackingState> {
  int? currentSessionId;
  TrackingViewModel() : super(TrackingState(isTracking: false, history: [])) {
    _loadHistory();
    _listenToBackgroundUpdates();
    // _checkServiceStatus();
    _loadTrackingStatus();
    _restoreTrackingState();
  }

  Future<void> _restoreTrackingState() async {
    final tracking = await AppPreferences.getTracking();

    state = state.copyWith(isTracking: tracking);
  }

  Future<void> _loadTrackingStatus() async {
    bool tracking = await AppPreferences.getTracking();

    state = state.copyWith(isTracking: tracking);
  }

  Future<void> _loadHistory() async {
    final data = await DBHelper.instance.fetchAllLocations();
    print("TOTAL RECORDS: ${data.length}");

    for (final item in data) {
      print(
        "Lat: ${item.latitude}, "
        "Lng: ${item.longitude}, "
        "Time: ${item.timestamp}, "
        "Accuracy: ${item.accuracy}",
      );
    }
    state = state.copyWith(history: data);
  }

  void _listenToBackgroundUpdates() {
    FlutterBackgroundService().on('onLocationUpdated').listen((event) {
      if (event != null) {
        _loadHistory();
      }
    });
  }

  Future<void> startTracking() async {
    await Permission.location.request();

    await Permission.locationAlways.request();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print("GPS OFF");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      print("Permission denied forever");
      return;
    }

    final service = FlutterBackgroundService();

    bool started = await service.startService();

    print("SERVICE STARTED ==========>>>>>>>>>>>> $started");

    if (started) {
      await AppPreferences.saveTracking(true);
      state = state.copyWith(isTracking: true);
    }
  }

  Future<void> stopTracking() async {
    if (currentSessionId != null) {
      await DBHelper.instance.finishSession(currentSessionId!);
    }
    FlutterBackgroundService().invoke("stopService");
    await AppPreferences.saveTracking(false);
    state = state.copyWith(isTracking: false);
    _loadHistory(); // Final refresh
  }
}

final trackingProvider =
    StateNotifierProvider<TrackingViewModel, TrackingState>((ref) {
      return TrackingViewModel();
    });
