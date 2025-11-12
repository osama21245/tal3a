class GroupTimeModel {
  final String id;
  final String timeSlot;
  final String day;
  final String date;
  final bool isSelected;
  final bool isAvailable;

  const GroupTimeModel({
    required this.id,
    required this.timeSlot,
    required this.day,
    required this.date,
    this.isSelected = false,
    this.isAvailable = true,
  });

  GroupTimeModel copyWith({
    String? id,
    String? timeSlot,
    String? day,
    String? date,
    bool? isSelected,
    bool? isAvailable,
  }) {
    return GroupTimeModel(
      id: id ?? this.id,
      timeSlot: timeSlot ?? this.timeSlot,
      day: day ?? this.day,
      date: date ?? this.date,
      isSelected: isSelected ?? this.isSelected,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  String toString() {
    return 'GroupTimeModel(id: $id, timeSlot: $timeSlot, day: $day, date: $date, isSelected: $isSelected, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupTimeModel &&
        other.id == id &&
        other.timeSlot == timeSlot &&
        other.day == day &&
        other.date == date &&
        other.isSelected == isSelected &&
        other.isAvailable == isAvailable;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timeSlot.hashCode ^
        day.hashCode ^
        date.hashCode ^
        isSelected.hashCode ^
        isAvailable.hashCode;
  }
}
