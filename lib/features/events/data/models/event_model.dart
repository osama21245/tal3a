class EventModel {
  final String id;
  final String name;
  final String description;
  final String eventIcon;
  final String dateOfEvent;
  final String location;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.eventIcon,
    required this.dateOfEvent,
    required this.location,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      eventIcon: json['eventIcon'] ?? '',
      dateOfEvent: json['dateOfEvent'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'eventIcon': eventIcon,
      'dateOfEvent': dateOfEvent,
      'location': location,
    };
  }

  EventModel copyWith({
    String? id,
    String? name,
    String? description,
    String? eventIcon,
    String? dateOfEvent,
    String? location,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      eventIcon: eventIcon ?? this.eventIcon,
      dateOfEvent: dateOfEvent ?? this.dateOfEvent,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.eventIcon == eventIcon &&
        other.dateOfEvent == dateOfEvent &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        eventIcon.hashCode ^
        dateOfEvent.hashCode ^
        location.hashCode;
  }

  @override
  String toString() {
    return 'EventModel(id: $id, name: $name, description: $description, eventIcon: $eventIcon, dateOfEvent: $dateOfEvent, location: $location)';
  }
}
