class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isVerified;
  final List<String> interests;
  final String gender;
  final bool profileCompletion;
  final bool isLocked;
  final String createdAt;
  final String? updatedAt;
  final String birthDate;
  final String height;
  final String weight;
  final String? resetCode;
  final String? resetCodeExpiry;
  final int resetAttempts;
  final bool isLockedByAdmin;
  final String? profilePic;
  final PackageSubscribed? packageSubscribed;
  final List<String> finders;
  final List<String> followers;
  final List<String> following;
  final String refreshToken;
  final String token;
  final int followersCount;
  final int followingCount;
  final int findersCount;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isVerified,
    required this.interests,
    required this.gender,
    required this.profileCompletion,
    required this.isLocked,
    required this.createdAt,
    this.updatedAt,
    required this.birthDate,
    required this.height,
    required this.weight,
    this.resetCode,
    this.resetCodeExpiry,
    required this.resetAttempts,
    required this.isLockedByAdmin,
    this.profilePic,
    this.packageSubscribed,
    required this.finders,
    required this.followers,
    required this.following,
    required this.refreshToken,
    required this.token,
    required this.followersCount,
    required this.followingCount,
    required this.findersCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      isVerified: json['isVerified'] ?? false,
      interests: List<String>.from(json['interests'] ?? []),
      gender: json['gender'] ?? '',
      profileCompletion: json['profileCompletion'] ?? false,
      isLocked: json['isLocked'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      birthDate: json['birthDate'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      resetCode: json['resetCode'],
      resetCodeExpiry: json['resetCodeExpiry'],
      resetAttempts: json['resetAttempts'] ?? 0,
      isLockedByAdmin: json['isLockedByAdmin'] ?? false,
      profilePic: json['profilePic'],
      packageSubscribed:
          json['packageSubscribed'] != null
              ? PackageSubscribed.fromJson(json['packageSubscribed'])
              : null,
      finders: List<String>.from(json['finders'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      refreshToken: json['refreshToken'] ?? '',
      token: json['token'] ?? '',
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      findersCount: json['findersCount'] ?? 0,
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
      'isLocked': isLocked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'birthDate': birthDate,
      'height': height,
      'weight': weight,
      'resetCode': resetCode,
      'resetCodeExpiry': resetCodeExpiry,
      'resetAttempts': resetAttempts,
      'isLockedByAdmin': isLockedByAdmin,
      'profilePic': profilePic,
      'packageSubscribed': packageSubscribed?.toJson(),
      'finders': finders,
      'followers': followers,
      'following': following,
      'refreshToken': refreshToken,
      'token': token,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'findersCount': findersCount,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? isVerified,
    List<String>? interests,
    String? gender,
    bool? profileCompletion,
    bool? isLocked,
    String? createdAt,
    String? updatedAt,
    String? birthDate,
    String? height,
    String? weight,
    String? resetCode,
    String? resetCodeExpiry,
    int? resetAttempts,
    bool? isLockedByAdmin,
    String? profilePic,
    PackageSubscribed? packageSubscribed,
    List<String>? finders,
    List<String>? followers,
    List<String>? following,
    String? refreshToken,
    String? token,
    int? followersCount,
    int? followingCount,
    int? findersCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      interests: interests ?? this.interests,
      gender: gender ?? this.gender,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      resetCode: resetCode ?? this.resetCode,
      resetCodeExpiry: resetCodeExpiry ?? this.resetCodeExpiry,
      resetAttempts: resetAttempts ?? this.resetAttempts,
      isLockedByAdmin: isLockedByAdmin ?? this.isLockedByAdmin,
      profilePic: profilePic ?? this.profilePic,
      packageSubscribed: packageSubscribed ?? this.packageSubscribed,
      finders: finders ?? this.finders,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      refreshToken: refreshToken ?? this.refreshToken,
      token: token ?? this.token,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      findersCount: findersCount ?? this.findersCount,
    );
  }
}

class PackageSubscribed {
  final String id;
  final String name;
  final String price;
  final String description;
  final String iconUrl;

  PackageSubscribed({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.iconUrl,
  });

  factory PackageSubscribed.fromJson(Map<String, dynamic> json) {
    return PackageSubscribed(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'description': description,
      'iconUrl': iconUrl,
    };
  }
}
