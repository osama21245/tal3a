class GroupRequestLocationPayload {
  final String type;
  final List<double> coordinates;
  final String locationName;

  const GroupRequestLocationPayload({
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

class GroupRequestPayload {
  final String groupTal3a;
  final String groupType; // "group_mix", "group_man", "group_woman"
  final GroupRequestLocationPayload location;
  final String date; // Format: "2025-11-01"
  final String time; // Format: "06:00" (from timeslot startTime)

  const GroupRequestPayload({
    required this.groupTal3a,
    required this.groupType,
    required this.location,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupTal3a': groupTal3a,
      'groupType': groupType,
      'location': location.toJson(),
      'date': date,
      'time': time,
    };
  }
}

