// Custom exceptions for different error types
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = "No Internet Connection"]);

  @override
  String toString() => message;
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException([this.message = "Authentication failed"]);

  @override
  String toString() => 'AuthenticationException: $message';
}

class ValidationException implements Exception {
  final String message;

  ValidationException([this.message = "Validation failed"]);

  @override
  String toString() => 'ValidationException: $message';
}

class AppTimeoutException implements Exception {
  final String message;

  AppTimeoutException([this.message = "Request timed out"]);

  @override
  String toString() => 'AppTimeoutException: $message';
}
