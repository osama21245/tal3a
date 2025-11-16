class WalkFriendModel {
  final String id;
  final String name;
  final String age;
  final String weight;
  final String? imageUrl;
  final bool isSelected;
  final String? email;
  final String? phoneNumber;
  final List<String> interests;
  final String? gender;
  final String? height;
  final String? packageSubscribed;
  final DateTime? birthDate;

  const WalkFriendModel({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    this.imageUrl,
    this.isSelected = false,
    this.email,
    this.phoneNumber,
    this.interests = const [],
    this.gender,
    this.height,
    this.packageSubscribed,
    this.birthDate,
  });

  factory WalkFriendModel.fromJson(Map<String, dynamic> json) {
    final rawBirthDate = json['birthDate'] as String?;
    final parsedBirthDate = _parseBirthDate(rawBirthDate);
    final age = _extractAge(json['age'], parsedBirthDate);
    final rawWeight = json['weight'];

    return WalkFriendModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['fullName'] ?? json['name'] ?? '').toString(),
      age: age,
      weight: _normalizeWeight(rawWeight),
      imageUrl: (json['profilePic'] ?? json['imageUrl']) as String?,
      isSelected: json['isSelected'] as bool? ?? false,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((interest) => interest.toString())
              .toList() ??
          const [],
      gender: json['gender'] as String?,
      height: json['height'] as String?,
      packageSubscribed: json['packageSubscribed']?.toString(),
      birthDate: parsedBirthDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'imageUrl': imageUrl,
      'isSelected': isSelected,
      'email': email,
      'phoneNumber': phoneNumber,
      'interests': interests,
      'gender': gender,
      'height': height,
      'packageSubscribed': packageSubscribed,
      'birthDate': birthDate?.toIso8601String(),
    };
  }

  WalkFriendModel copyWith({
    String? id,
    String? name,
    String? age,
    String? weight,
    String? imageUrl,
    bool? isSelected,
    String? email,
    String? phoneNumber,
    List<String>? interests,
    String? gender,
    String? height,
    String? packageSubscribed,
    DateTime? birthDate,
  }) {
    return WalkFriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      isSelected: isSelected ?? this.isSelected,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      interests: interests ?? this.interests,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      packageSubscribed: packageSubscribed ?? this.packageSubscribed,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  static DateTime? _parseBirthDate(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(birthDate).toLocal();
    } catch (_) {
      return null;
    }
  }

  static String _extractAge(dynamic ageValue, DateTime? birthDate) {
    if (ageValue != null) {
      final ageString = ageValue.toString();
      final ageDigits = RegExp(r'(\d+)').firstMatch(ageString);
      if (ageDigits != null) {
        return ageDigits.group(1)!;
      }
    }

    if (birthDate != null) {
      final now = DateTime.now();
      var age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      if (age < 0) {
        age = 0;
      }
      return age.toString();
    }

    return '';
  }

  static String _normalizeWeight(dynamic weightValue) {
    if (weightValue == null) {
      return '';
    }

    final weightString = weightValue.toString();
    final weightDigits = RegExp(r'(\d+(\.\d+)?)').firstMatch(weightString);
    if (weightDigits != null) {
      return weightDigits.group(1)!;
    }

    return weightString;
  }
}
