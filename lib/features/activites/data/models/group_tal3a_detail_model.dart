class GroupTal3aDetailTimeSlot {
  final String id;
  final String startTime;
  final String endTime;

  const GroupTal3aDetailTimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory GroupTal3aDetailTimeSlot.fromJson(Map<String, dynamic> json) {
    return GroupTal3aDetailTimeSlot(
      id: json['_id'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'startTime': startTime, 'endTime': endTime};
  }
}

class GroupTal3aDetailModel {
  final String id;
  final String name;
  final String nameAr;
  final String locationName;
  final DateTime date;
  final List<GroupTal3aDetailTimeSlot> timeSlots;
  final GroupTal3aDetailLocationCoordinates location;
  final bool isSelected;

  const GroupTal3aDetailModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.locationName,
    required this.date,
    required this.timeSlots,
    required this.location,
    this.isSelected = false,
  });

  factory GroupTal3aDetailModel.fromJson(Map<String, dynamic> json) {
    return GroupTal3aDetailModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String? ?? '',
      locationName: json['locationName'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlots:
          (json['timeSlots'] as List<dynamic>?)
              ?.map(
                (slot) => GroupTal3aDetailTimeSlot.fromJson(
                  slot as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      location: GroupTal3aDetailLocationCoordinates.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'nameAr': nameAr,
      'locationName': locationName,
      'date': date.toIso8601String(),
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
      'location': location.toJson(),
    };
  }

  GroupTal3aDetailModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? locationName,
    DateTime? date,
    List<GroupTal3aDetailTimeSlot>? timeSlots,
    GroupTal3aDetailLocationCoordinates? location,
    bool? isSelected,
  }) {
    return GroupTal3aDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      locationName: locationName ?? this.locationName,
      date: date ?? this.date,
      timeSlots: timeSlots ?? this.timeSlots,
      location: location ?? this.location,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class GroupTal3aDetailLocationCoordinates {
  final String type;
  final List<double> coordinates;

  const GroupTal3aDetailLocationCoordinates({
    required this.type,
    required this.coordinates,
  });

  factory GroupTal3aDetailLocationCoordinates.fromJson(
    Map<String, dynamic> json,
  ) {
    return GroupTal3aDetailLocationCoordinates(
      type: json['type'] as String,
      coordinates:
          (json['coordinates'] as List<dynamic>)
              .map((coord) => (coord as num).toDouble())
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
}
