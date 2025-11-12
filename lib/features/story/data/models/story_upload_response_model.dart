class StoryUploadResponseModel {
  final bool success;
  final String message;
  final String? storyId;
  final String? imageUrl;

  StoryUploadResponseModel({
    required this.success,
    required this.message,
    this.storyId,
    this.imageUrl,
  });

  factory StoryUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return StoryUploadResponseModel(
      success: json['status'] ?? json['success'] ?? false,
      message: json['message'] ?? '',
      storyId:
          json['stories'] != null && (json['stories'] as List).isNotEmpty
              ? (json['stories'] as List).first['_id']
              : json['storyId'],
      imageUrl:
          json['stories'] != null && (json['stories'] as List).isNotEmpty
              ? (json['stories'] as List).first['media']
              : json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'storyId': storyId,
      'imageUrl': imageUrl,
    };
  }
}
