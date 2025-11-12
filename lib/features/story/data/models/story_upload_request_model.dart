import 'dart:io';

class StoryUploadRequestModel {
  final File image;
  final String note;

  StoryUploadRequestModel({required this.image, required this.note});

  Map<String, dynamic> toJson() {
    return {'note': note};
  }
}
