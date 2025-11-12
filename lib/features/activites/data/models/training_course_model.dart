class TrainingCourseModel {
  final String id;
  final String title;
  final String description;
  final double rating;
  final int reviewCount;
  final String duration; // e.g., "5h 30m"
  final String thumbnailUrl;
  final String videoUrl;
  final List<TrainingSessionModel> sessions;
  final bool isBookmarked;

  const TrainingCourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.sessions,
    this.isBookmarked = false,
  });

  factory TrainingCourseModel.fromJson(Map<String, dynamic> json) {
    return TrainingCourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      duration: json['duration'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      sessions:
          (json['sessions'] as List)
              .map((session) => TrainingSessionModel.fromJson(session))
              .toList(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'duration': duration,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'isBookmarked': isBookmarked,
    };
  }

  TrainingCourseModel copyWith({
    String? id,
    String? title,
    String? description,
    double? rating,
    int? reviewCount,
    String? duration,
    String? thumbnailUrl,
    String? videoUrl,
    List<TrainingSessionModel>? sessions,
    bool? isBookmarked,
  }) {
    return TrainingCourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      duration: duration ?? this.duration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      sessions: sessions ?? this.sessions,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class TrainingSessionModel {
  final String id;
  final String title;
  final String duration; // e.g., "13:02"
  final bool isUnlocked;
  final bool isCompleted;
  final String? videoUrl;
  final String? thumbnailUrl;

  const TrainingSessionModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.isUnlocked,
    this.isCompleted = false,
    this.videoUrl,
    this.thumbnailUrl,
  });

  factory TrainingSessionModel.fromJson(Map<String, dynamic> json) {
    return TrainingSessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      isUnlocked: json['isUnlocked'] as bool,
      isCompleted: json['isCompleted'] as bool? ?? false,
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  TrainingSessionModel copyWith({
    String? id,
    String? title,
    String? duration,
    bool? isUnlocked,
    bool? isCompleted,
    String? videoUrl,
    String? thumbnailUrl,
  }) {
    return TrainingSessionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
