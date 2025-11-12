class WalkGenderModel {
  final String id;
  final String name;
  final String iconPath;
  final bool isSelected;

  const WalkGenderModel({
    required this.id,
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  factory WalkGenderModel.fromJson(Map<String, dynamic> json) {
    return WalkGenderModel(
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

  WalkGenderModel copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
  }) {
    return WalkGenderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
