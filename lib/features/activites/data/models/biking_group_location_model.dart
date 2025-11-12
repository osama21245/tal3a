class BikingGroupLocationModel {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;

  const BikingGroupLocationModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory BikingGroupLocationModel.fromJson(Map<String, dynamic> json) {
    return BikingGroupLocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingGroupLocationModel &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;

  @override
  String toString() =>
      'BikingGroupLocationModel(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude)';
}
