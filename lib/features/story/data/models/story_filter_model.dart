class StoryFilterModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? previewUrl;
  final bool isSelected;

  StoryFilterModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.previewUrl,
    this.isSelected = false,
  });

  factory StoryFilterModel.fromJson(Map<String, dynamic> json) {
    return StoryFilterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      previewUrl: json['previewUrl'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'previewUrl': previewUrl,
      'isSelected': isSelected,
    };
  }

  StoryFilterModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? previewUrl,
    bool? isSelected,
  }) {
    return StoryFilterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
