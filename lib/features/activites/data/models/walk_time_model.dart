class WalkTimeModel {
  final String id;
  final String timeSlot;
  final bool isSelected;
  final bool isAvailable;
  final DateTime? scheduledAt;

  const WalkTimeModel({
    required this.id,
    required this.timeSlot,
    this.isSelected = false,
    this.isAvailable = true,
    this.scheduledAt,
  });

  factory WalkTimeModel.fromJson(Map<String, dynamic> json) {
    return WalkTimeModel(
      id: json['id'] as String,
      timeSlot: json['timeSlot'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
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
      'isSelected': isSelected,
      'isAvailable': isAvailable,
      'scheduledAt': scheduledAt?.toIso8601String(),
    };
  }

  WalkTimeModel copyWith({
    String? id,
    String? timeSlot,
    bool? isSelected,
    bool? isAvailable,
    DateTime? scheduledAt,
  }) {
    return WalkTimeModel(
      id: id ?? this.id,
      timeSlot: timeSlot ?? this.timeSlot,
      isSelected: isSelected ?? this.isSelected,
      isAvailable: isAvailable ?? this.isAvailable,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }
}
