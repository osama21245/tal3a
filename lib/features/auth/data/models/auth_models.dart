// Signup Request Model
class SignupRequest {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  SignupRequest({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }
}

// Signup Response Model
class SignupResponse {
  final String message;
  final String userId;
  final bool status;

  SignupResponse({
    required this.message,
    required this.userId,
    required this.status,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? false,
    );
  }
}

// Login Request Model
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

// Login Response Model
class LoginResponse {
  final String message;
  final String? token;
  final String? userId;
  final bool status;

  LoginResponse({
    required this.message,
    this.token,
    this.userId,
    required this.status,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      token: json['token'],
      userId: json['userId'],
      status: json['status'] ?? false,
    );
  }
}
