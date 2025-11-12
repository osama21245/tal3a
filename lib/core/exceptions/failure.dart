// Failure class to represent errors in the app
class Failure {
  final String message;
  final String? code;
  final int? statusCode;

  Failure([
    this.message = "Unexpected error occurred",
    this.code,
    this.statusCode,
  ]);

  @override
  String toString() => 'Failure: $message';
}

// Specific failure types
class NetworkFailure extends Failure {
  NetworkFailure([
    String message =
        "Network error. Please check your connection and try again.",
  ]) : super(message, 'NETWORK_ERROR');
}

class ServerFailure extends Failure {
  ServerFailure([String message = "Server error. Please try again later."])
    : super(message, 'SERVER_ERROR');
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure([
    String message = "Authentication failed. Please login again.",
  ]) : super(message, 'AUTH_ERROR');
}

class ValidationFailure extends Failure {
  ValidationFailure([String message = "Invalid input. Please check your data."])
    : super(message, 'VALIDATION_ERROR');
}

class TimeoutFailure extends Failure {
  TimeoutFailure([String message = "Request timed out. Please try again."])
    : super(message, 'TIMEOUT_ERROR');
}
