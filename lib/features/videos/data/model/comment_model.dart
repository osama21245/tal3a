class CommentModel {
  final String id;
  final String videoId;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String text;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.videoId,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      videoId: json['video'] ?? '',
      userId: json['user']?['_id'] ?? '',
      userName: json['user']?['fullName'] ?? '',
      userImageUrl: json['user']?['profilePic'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
