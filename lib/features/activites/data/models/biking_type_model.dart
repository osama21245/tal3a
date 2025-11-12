class BikingTypeModel {
  final String id;
  final String name;

  const BikingTypeModel({required this.id, required this.name});

  factory BikingTypeModel.fromJson(Map<String, dynamic> json) {
    return BikingTypeModel(
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
    return other is BikingTypeModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'BikingTypeModel(id: $id, name: $name)';
}
