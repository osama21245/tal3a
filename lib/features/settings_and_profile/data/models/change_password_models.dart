class ChangePasswordRequestModel {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {'oldPassword': oldPassword, 'newPassword': newPassword};
  }

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequestModel(
      oldPassword: json['oldPassword'] ?? '',
      newPassword: json['newPassword'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ChangePasswordRequestModel(oldPassword: $oldPassword, newPassword: $newPassword)';
  }
}

class ChangePasswordResponseModel {
  final bool success;
  final String? message;
  final String? error;

  ChangePasswordResponseModel({
    required this.success,
    this.message,
    this.error,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      error: json['error'],
    );
  }

  @override
  String toString() {
    return 'ChangePasswordResponseModel(success: $success, message: $message, error: $error)';
  }
}
