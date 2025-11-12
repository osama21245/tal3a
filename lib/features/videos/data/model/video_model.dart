class VideoModel {
  final String id;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String videoUrl;
  final String description;
  final int likes;
  final int shares;
  final int views;
  final bool isLiked;
  final bool isFollowed;
  final String status;
  final List<String> hashtags;

  const VideoModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.videoUrl,
    required this.description,
    required this.likes,
    required this.shares,
    required this.views,
    this.isLiked = false,
    this.isFollowed = false,
    this.status = '',
    this.hashtags = const [],
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'] ?? '',
      userId: json['user']?['_id'] ?? '',
      userName: json['user']?['fullName'] ?? '',
      userImageUrl: json['user']?['profilePic'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      description: json['description'] ?? '',
      likes: json['likesCount'] ?? 0,
      shares: json['shares'] ?? 0,
      views: json['views'] ?? 0,
      status: json['status'] ?? '',
      hashtags: (json['hashtags'] != null)
          ? List<String>.from(json['hashtags'])
          : const [],
    );
  }

  VideoModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? videoUrl,
    String? description,
    int? likes,
    int? shares,
    int? views,
    bool? isLiked,
    bool? isFollowed,
    String? status,
    List<String>? hashtags,
  }) {
    return VideoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      views: views ?? this.views,
      isLiked: isLiked ?? this.isLiked,
      isFollowed: isFollowed ?? this.isFollowed,
      status: status ?? this.status,
      hashtags: hashtags ?? this.hashtags,
    );
  }
}
