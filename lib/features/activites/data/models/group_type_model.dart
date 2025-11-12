class GroupTypeModel {
  final String id;
  final String name;
  final String iconPath;
  final bool isSelected;

  const GroupTypeModel({
    required this.id,
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  GroupTypeModel copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
  }) {
    return GroupTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'GroupTypeModel(id: $id, name: $name, iconPath: $iconPath, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupTypeModel &&
        other.id == id &&
        other.name == name &&
        other.iconPath == iconPath &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        iconPath.hashCode ^
        isSelected.hashCode;
  }
}
