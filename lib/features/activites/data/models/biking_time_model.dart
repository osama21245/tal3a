class BikingTimeModel {
  final String id;
  final String timeSlot;
  final String description;
  final DateTime? scheduledAt;

  const BikingTimeModel({
    required this.id,
    required this.timeSlot,
    required this.description,
    this.scheduledAt,
  });

  factory BikingTimeModel.fromJson(Map<String, dynamic> json) {
    return BikingTimeModel(
      id: json['id'] as String,
      timeSlot: json['timeSlot'] as String,
      description: json['description'] as String,
      scheduledAt:
          json['scheduledAt'] != null
              ? DateTime.tryParse(json['scheduledAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timeSlot': timeSlot,
      'description': description,
      'scheduledAt': scheduledAt?.toIso8601String(),
    };
  }

  BikingTimeModel copyWith({
    String? id,
    String? timeSlot,
    String? description,
    DateTime? scheduledAt,
  }) {
    return BikingTimeModel(
      id: id ?? this.id,
      timeSlot: timeSlot ?? this.timeSlot,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingTimeModel &&
        other.id == id &&
        other.timeSlot == timeSlot &&
        other.description == description &&
        other.scheduledAt == scheduledAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      timeSlot.hashCode ^
      description.hashCode ^
      scheduledAt.hashCode;

  @override
  String toString() =>
      'BikingTimeModel(id: $id, timeSlot: $timeSlot, description: $description, scheduledAt: $scheduledAt)';
}
