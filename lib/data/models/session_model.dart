class SessionModel {
  final int? id;
  final DateTime startTime;
  final DateTime? endTime;
  final int totalPoints;

  SessionModel({
    this.id,
    required this.startTime,
    this.endTime,
    required this.totalPoints,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'total_points': totalPoints,
    };
  }
}
