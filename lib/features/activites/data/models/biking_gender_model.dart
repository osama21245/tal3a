class BikingGenderModel {
  final String id;
  final String name;

  const BikingGenderModel({required this.id, required this.name});

  factory BikingGenderModel.fromJson(Map<String, dynamic> json) {
    return BikingGenderModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingGenderModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'BikingGenderModel(id: $id, name: $name)';
}
