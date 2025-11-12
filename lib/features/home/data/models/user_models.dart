// User data models for home feature
// Following the same pattern as auth_models.dart

class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isVerified;
  final List<String> interests;
  final String gender;
  final bool profileCompletion;
  final String? birthDate;
  final String? height;
  final String? weight;
  final String? profilePic;
  final int finders;
  final int followers;
  final int following;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isVerified,
    required this.interests,
    required this.gender,
    required this.profileCompletion,
    this.birthDate,
    this.height,
    this.weight,
    this.profilePic,
    required this.finders,
    required this.followers,
    required this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      isVerified: json['isVerified'] ?? false,
      interests: List<String>.from(json['interests'] ?? []),
      gender: json['gender'] ?? 'notSet',
      profileCompletion: json['profileCompletion'] ?? false,
      birthDate: json['birthDate'],
      height: json['height'],
      weight: json['weight'],
      profilePic: json['profilePic'],
      finders: json['finders'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'interests': interests,
      'gender': gender,
      'profileCompletion': profileCompletion,
      'birthDate': birthDate,
      'height': height,
      'weight': weight,
      'profilePic': profilePic,
      'finders': finders,
      'followers': followers,
      'following': following,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, isVerified: $isVerified, interests: $interests, gender: $gender, profileCompletion: $profileCompletion, birthDate: $birthDate, height: $height, weight: $weight, profilePic: $profilePic, finders: $finders, followers: $followers, following: $following)';
  }
}

class UsersResponse {
  final bool status;
  final List<User> users;
  final int currentPage;
  final int totalUsers;
  final int totalPages;
  final int limitPerPage;

  UsersResponse({
    required this.status,
    required this.users,
    required this.currentPage,
    required this.totalUsers,
    required this.totalPages,
    required this.limitPerPage,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      status: json['status'] ?? false,
      users:
          (json['users'] as List<dynamic>?)
              ?.map((userJson) => User.fromJson(userJson))
              .toList() ??
          [],
      currentPage: json['currentPage'] ?? 1,
      totalUsers: json['totalUsers'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      limitPerPage: json['limitPerPage'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'users': users.map((user) => user.toJson()).toList(),
      'currentPage': currentPage,
      'totalUsers': totalUsers,
      'totalPages': totalPages,
      'limitPerPage': limitPerPage,
    };
  }

  @override
  String toString() {
    return 'UsersResponse(status: $status, users: $users, currentPage: $currentPage, totalUsers: $totalUsers, totalPages: $totalPages, limitPerPage: $limitPerPage)';
  }
}
