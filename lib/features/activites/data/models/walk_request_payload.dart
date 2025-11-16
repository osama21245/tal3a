class WalkRequestLocationPayload {
  final String type;
  final List<double> coordinates;
  final String locationName;

  const WalkRequestLocationPayload({
    required this.type,
    required this.coordinates,
    required this.locationName,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'locationName': locationName,
    };
  }
}

class WalkRequestPayload {
  final String requestReceiverId;
  final String type;
  final DateTime scheduledAt;
  final WalkRequestLocationPayload location;

  const WalkRequestPayload({
    required this.requestReceiverId,
    required this.type,
    required this.scheduledAt,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestReceiver': requestReceiverId,
      'type': type,
      'time': scheduledAt.toUtc().toIso8601String(),
      'location': location.toJson(),
    };
  }
}
