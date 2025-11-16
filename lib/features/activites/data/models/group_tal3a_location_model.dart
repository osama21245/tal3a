class GroupTal3aTimeSlot {
  final String id;
  final String startTime;
  final String endTime;

  const GroupTal3aTimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory GroupTal3aTimeSlot.fromJson(Map<String, dynamic> json) {
    return GroupTal3aTimeSlot(
      id: json['_id'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class GroupTal3aLocationModel {
  final String name;
  final String nameAr;
  final String locationName;
  final List<GroupTal3aTimeSlot> timeSlots;
  final GroupTal3aLocationCoordinates location;
  final bool isSelected;

  const GroupTal3aLocationModel({
    required this.name,
    required this.nameAr,
    required this.locationName,
    required this.timeSlots,
    required this.location,
    this.isSelected = false,
  });

  factory GroupTal3aLocationModel.fromJson(Map<String, dynamic> json) {
    return GroupTal3aLocationModel(
      name: json['name'] as String,
      nameAr: json['nameAr'] as String? ?? '',
      locationName: json['locationName'] as String,
      timeSlots: (json['timeSlots'] as List<dynamic>?)
              ?.map((slot) => GroupTal3aTimeSlot.fromJson(slot as Map<String, dynamic>))
              .toList() ??
          [],
      location: GroupTal3aLocationCoordinates.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameAr': nameAr,
      'locationName': locationName,
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
      'location': location.toJson(),
    };
  }

  GroupTal3aLocationModel copyWith({
    String? name,
    String? nameAr,
    String? locationName,
    List<GroupTal3aTimeSlot>? timeSlots,
    GroupTal3aLocationCoordinates? location,
    bool? isSelected,
  }) {
    return GroupTal3aLocationModel(
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      locationName: locationName ?? this.locationName,
      timeSlots: timeSlots ?? this.timeSlots,
      location: location ?? this.location,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class GroupTal3aLocationCoordinates {
  final String type;
  final List<double> coordinates;

  const GroupTal3aLocationCoordinates({
    required this.type,
    required this.coordinates,
  });

  factory GroupTal3aLocationCoordinates.fromJson(Map<String, dynamic> json) {
    return GroupTal3aLocationCoordinates(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((coord) => (coord as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
}

