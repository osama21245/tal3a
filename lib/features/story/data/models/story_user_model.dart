class StoryUserModel {
  final String id;
  final String fullName;
  final String? profilePic;

  StoryUserModel({required this.id, required this.fullName, this.profilePic});

  factory StoryUserModel.fromJson(Map<String, dynamic> json) {
    return StoryUserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'fullName': fullName, 'profilePic': profilePic};
  }

  StoryUserModel copyWith({String? id, String? fullName, String? profilePic}) {
    return StoryUserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
