import 'dart:io';

class VideoUploadRequestModel {
  final String description;
  final List<String> hashtags;
  final File  videoFile;

  VideoUploadRequestModel({
    required this.description,
    required this.hashtags,
    required this.videoFile,
  });
}
