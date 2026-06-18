class LocationModel {
  final int? id;
  final int? sessionId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double accuracy;

  LocationModel({
    this.id,
    this.sessionId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.accuracy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
      'session_id': sessionId,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      accuracy: (map['accuracy'] as num).toDouble(),
      sessionId: map['session_id'],
    );
  }
}
