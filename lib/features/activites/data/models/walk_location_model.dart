class WalkLocationModel {
  final String id;
  final String name;
  final String locationName;
  final double latitude;
  final double longitude;
  final bool isSelected;
  final String? description;

  const WalkLocationModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    this.isSelected = false,
    this.description,
  });

  WalkLocationModel copyWith({
    String? id,
    String? name,
    String? locationName,
    double? latitude,
    double? longitude,
    bool? isSelected,
    String? description,
  }) {
    return WalkLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSelected: isSelected ?? this.isSelected,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    };
  }
}
