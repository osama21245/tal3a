class BikingGroupTypeModel {
  final String id;
  final String name;
  final String iconPath;
  final bool isSelected;

  const BikingGroupTypeModel({
    required this.id,
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  factory BikingGroupTypeModel.fromJson(Map<String, dynamic> json) {
    return BikingGroupTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconPath: json['iconPath'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'isSelected': isSelected,
    };
  }

  BikingGroupTypeModel copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
  }) {
    return BikingGroupTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingGroupTypeModel &&
        other.id == id &&
        other.name == name &&
        other.iconPath == iconPath &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ iconPath.hashCode ^ isSelected.hashCode;

  @override
  String toString() =>
      'BikingGroupTypeModel(id: $id, name: $name, iconPath: $iconPath, isSelected: $isSelected)';
}
