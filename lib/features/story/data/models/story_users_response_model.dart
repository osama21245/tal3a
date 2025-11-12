import 'story_user_model.dart';

class StoryUsersResponseModel {
  final bool status;
  final String message;
  final StoryUserModel? myStory;
  final List<StoryUserModel> otherUsers;

  StoryUsersResponseModel({
    required this.status,
    required this.message,
    this.myStory,
    required this.otherUsers,
  });

  factory StoryUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return StoryUsersResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      myStory:
          json['myStory'] != null
              ? StoryUserModel.fromJson(json['myStory'] as Map<String, dynamic>)
              : null,
      otherUsers:
          (json['otherUsers'] as List<dynamic>?)
              ?.map(
                (user) => StoryUserModel.fromJson(user as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  // Get all users with myStory first if it exists
  List<StoryUserModel> get allUsers {
    List<StoryUserModel> users = [];
    if (myStory != null) {
      users.add(myStory!);
    }
    users.addAll(otherUsers);
    return users;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'myStory': myStory?.toJson(),
      'otherUsers': otherUsers.map((user) => user.toJson()).toList(),
    };
  }
}
