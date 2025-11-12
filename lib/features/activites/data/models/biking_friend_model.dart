class BikingFriendModel {
  final String id;
  final String name;
  final int age;
  final int weight;
  final String? imageUrl;

  const BikingFriendModel({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    this.imageUrl,
  });

  factory BikingFriendModel.fromJson(Map<String, dynamic> json) {
    return BikingFriendModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      weight: json['weight'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'imageUrl': imageUrl,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingFriendModel &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.weight == weight &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      age.hashCode ^
      weight.hashCode ^
      imageUrl.hashCode;

  @override
  String toString() =>
      'BikingFriendModel(id: $id, name: $name, age: $age, weight: $weight, imageUrl: $imageUrl)';
}
