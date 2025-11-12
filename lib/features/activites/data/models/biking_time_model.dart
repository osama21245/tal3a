class BikingTimeModel {
  final String id;
  final String timeSlot;
  final String description;

  const BikingTimeModel({
    required this.id,
    required this.timeSlot,
    required this.description,
  });

  factory BikingTimeModel.fromJson(Map<String, dynamic> json) {
    return BikingTimeModel(
      id: json['id'] as String,
      timeSlot: json['timeSlot'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'timeSlot': timeSlot, 'description': description};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingTimeModel &&
        other.id == id &&
        other.timeSlot == timeSlot &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ timeSlot.hashCode ^ description.hashCode;

  @override
  String toString() =>
      'BikingTimeModel(id: $id, timeSlot: $timeSlot, description: $description)';
}
