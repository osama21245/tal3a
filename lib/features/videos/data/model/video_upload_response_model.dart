class VideoUploadResponseModel {
  final String id;
  final String videoKey;
  final String description;
  final List<String> hashtags;
  final int views;
  final String createdAt;

  VideoUploadResponseModel({
    required this.id,
    required this.videoKey,
    required this.description,
    required this.hashtags,
    required this.views,
    required this.createdAt,
  });

  factory VideoUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return VideoUploadResponseModel(
      id: json['_id'],
      videoKey: json['videoKey'],
      description: json['description'],
      hashtags: List<String>.from(json['hashtags']),
      views: json['views'],
      createdAt: json['createdAt'],
    );
  }
}
