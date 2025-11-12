class ProfileSetupRequestModel {
  final List<String> interests;
  final String gender;
  final String birthDate;
  final String weight;
  final String height;

  ProfileSetupRequestModel({
    required this.interests,
    required this.gender,
    required this.birthDate,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'interests': interests, // Keep as array
      'gender': gender,
      'birthDate': birthDate, // Format: YYYY-MM-DD
      'weight': weight,
      'height': height,
    };
  }
}
