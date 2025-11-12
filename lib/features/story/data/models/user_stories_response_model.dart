import 'story_item_model.dart';

class UserStoriesResponseModel {
  final bool status;
  final String message;
  final List<StoryItemModel> stories;

  UserStoriesResponseModel({
    required this.status,
    required this.message,
    required this.stories,
  });

  factory UserStoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return UserStoriesResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      stories:
          (json['stories'] as List<dynamic>?)
              ?.map(
                (story) =>
                    StoryItemModel.fromJson(story as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'stories': stories.map((story) => story.toJson()).toList(),
    };
  }
}
