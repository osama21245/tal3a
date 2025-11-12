class RefreshTokenResponseModel {
  final String message;
  final String accessToken;
  final String newRefreshToken;

  RefreshTokenResponseModel({
    required this.message,
    required this.accessToken,
    required this.newRefreshToken,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      message: json['message'] ?? '',
      accessToken: json['accessToken'] ?? '',
      newRefreshToken: json['newRefreshToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'accessToken': accessToken,
      'newRefreshToken': newRefreshToken,
    };
  }
}
