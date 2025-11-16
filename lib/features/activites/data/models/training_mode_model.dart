class TrainingModeModel {
  final String id;
  final String name;
  final String description;
  final String? thumbnail;

  const TrainingModeModel({
    required this.id,
    required this.name,
    required this.description,
    this.thumbnail,
  });

  factory TrainingModeModel.fromJson(Map<String, dynamic> json) {
    return TrainingModeModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      thumbnail: json['thumbnail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  TrainingModeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnail,
  }) {
    return TrainingModeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingModeModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ thumbnail.hashCode;
}

