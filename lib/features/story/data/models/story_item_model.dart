class StoryItemModel {
  final String id;
  final String url;
  final String note;
  final String mimetype;
  final DateTime createdAt;

  StoryItemModel({
    required this.id,
    required this.url,
    required this.note,
    required this.mimetype,
    required this.createdAt,
  });

  factory StoryItemModel.fromJson(Map<String, dynamic> json) {
    return StoryItemModel(
      id: json['_id'] ?? '',
      url: json['url'] ?? '',
      note: json['note'] ?? '',
      mimetype: json['mimetype'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'url': url,
      'note': note,
      'mimetype': mimetype,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  StoryItemModel copyWith({
    String? id,
    String? url,
    String? note,
    String? mimetype,
    DateTime? createdAt,
  }) {
    return StoryItemModel(
      id: id ?? this.id,
      url: url ?? this.url,
      note: note ?? this.note,
      mimetype: mimetype ?? this.mimetype,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
