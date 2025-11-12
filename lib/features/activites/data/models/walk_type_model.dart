class WalkTypeModel {
  final String id;
  final String name;
  final String? iconPath;
  final bool isSelected;

  const WalkTypeModel({
    required this.id,
    required this.name,
    this.iconPath,
    this.isSelected = false,
  });

  factory WalkTypeModel.fromJson(Map<String, dynamic> json) {
    return WalkTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconPath: json['iconPath'] as String?,
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

  WalkTypeModel copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
  }) {
    return WalkTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
