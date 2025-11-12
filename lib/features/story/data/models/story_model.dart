class StoryModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userImageUrl;
  final String? imageUrl;
  final String? videoUrl;
  final String? text;
  final DateTime createdAt;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isViewed;
  final String? filterType;

  StoryModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userImageUrl,
    this.imageUrl,
    this.videoUrl,
    this.text,
    required this.createdAt,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isViewed = false,
    this.filterType,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userImageUrl: json['userImageUrl'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      text: json['text'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isViewed: json['isViewed'] ?? false,
      filterType: json['filterType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userImageUrl': userImageUrl,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isLiked': isLiked,
      'isViewed': isViewed,
      'filterType': filterType,
    };
  }

  StoryModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userImageUrl,
    String? imageUrl,
    String? videoUrl,
    String? text,
    DateTime? createdAt,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isViewed,
    String? filterType,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isViewed: isViewed ?? this.isViewed,
      filterType: filterType ?? this.filterType,
    );
  }
}
