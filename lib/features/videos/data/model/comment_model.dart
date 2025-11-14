class CommentModel {
  final String id;
  final String videoId;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String text;
  final bool isPending;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.videoId,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.text,
    required this.isPending,
    required this.createdAt,
  });

  CommentModel copyWith({
    String? id,
    String? videoId,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? text,
    DateTime? createdAt,
    bool? isPending,
  }) {
    return CommentModel(
      id: id ?? this.id,
      videoId: videoId ?? this.videoId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isPending: isPending ?? this.isPending,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      videoId: json['video'] ?? '',
      userId: json['user']?['_id'] ?? '',
      userName: json['user']?['fullName'] ?? '',
      userImageUrl: json['user']?['profilePic'] ?? '',
      text: json['text'] ?? '',
       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isPending: false,
    );
  }

}
