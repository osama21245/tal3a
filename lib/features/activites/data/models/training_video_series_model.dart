class TrainingVideoSeriesModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int seriesOrder;
  final String coachId;
  final String coachName;
  final String trainingModeId;
  final String trainingModeName;

  const TrainingVideoSeriesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.seriesOrder,
    required this.coachId,
    required this.coachName,
    required this.trainingModeId,
    required this.trainingModeName,
  });

  factory TrainingVideoSeriesModel.fromJson(Map<String, dynamic> json) {
    final coach = json['coach'] as Map<String, dynamic>? ?? {};
    final trainingMode = json['trainingMode'] as Map<String, dynamic>? ?? {};

    return TrainingVideoSeriesModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      videoUrl: (json['videoUrl'] ?? '').toString(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      seriesOrder: (json['seriesOrder'] as num?)?.toInt() ?? 0,
      coachId: (coach['_id'] ?? coach['id'] ?? '').toString(),
      coachName: (coach['name'] ?? '').toString(),
      trainingModeId: (trainingMode['_id'] ?? trainingMode['id'] ?? '').toString(),
      trainingModeName: (trainingMode['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'seriesOrder': seriesOrder,
      'coachId': coachId,
      'coachName': coachName,
      'trainingModeId': trainingModeId,
      'trainingModeName': trainingModeName,
    };
  }

  TrainingVideoSeriesModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    int? seriesOrder,
    String? coachId,
    String? coachName,
    String? trainingModeId,
    String? trainingModeName,
  }) {
    return TrainingVideoSeriesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      seriesOrder: seriesOrder ?? this.seriesOrder,
      coachId: coachId ?? this.coachId,
      coachName: coachName ?? this.coachName,
      trainingModeId: trainingModeId ?? this.trainingModeId,
      trainingModeName: trainingModeName ?? this.trainingModeName,
    );
  }
}

