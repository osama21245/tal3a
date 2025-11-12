class WalkFriendModel {
  final String id;
  final String name;
  final String age;
  final String weight;
  final String? imageUrl;
  final bool isSelected;

  const WalkFriendModel({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    this.imageUrl,
    this.isSelected = false,
  });

  factory WalkFriendModel.fromJson(Map<String, dynamic> json) {
    return WalkFriendModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      weight: json['weight'] as String,
      imageUrl: json['imageUrl'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'imageUrl': imageUrl,
      'isSelected': isSelected,
    };
  }

  WalkFriendModel copyWith({
    String? id,
    String? name,
    String? age,
    String? weight,
    String? imageUrl,
    bool? isSelected,
  }) {
    return WalkFriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
