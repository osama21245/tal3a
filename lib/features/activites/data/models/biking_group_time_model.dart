class BikingGroupTimeModel {
  final String id;
  final String timeSlot;
  final String description;
  final String date;

  const BikingGroupTimeModel({
    required this.id,
    required this.timeSlot,
    required this.description,
    required this.date,
  });

  factory BikingGroupTimeModel.fromJson(Map<String, dynamic> json) {
    return BikingGroupTimeModel(
      id: json['id'] as String,
      timeSlot: json['timeSlot'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timeSlot': timeSlot,
      'description': description,
      'date': date,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingGroupTimeModel &&
        other.id == id &&
        other.timeSlot == timeSlot &&
        other.description == description &&
        other.date == date;
  }

  @override
  int get hashCode =>
      id.hashCode ^ timeSlot.hashCode ^ description.hashCode ^ date.hashCode;

  @override
  String toString() =>
      'BikingGroupTimeModel(id: $id, timeSlot: $timeSlot, description: $description, date: $date)';
}
