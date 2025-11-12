// Error constants for consistent error messages
class ErrorConstants {
  // Network errors
  static const String networkError =
      "Network error. Please check your connection and try again.";
  static const String noInternetError =
      "No internet connection. Please check your network and try again.";
  static const String timeoutError = "Request timed out. Please try again.";

  // Authentication errors
  static const String authenticationError =
      "Authentication failed. Please login again.";
  static const String unauthorizedError = "Unauthorized. Please login again.";
  static const String tokenExpiredError =
      "Session expired. Please login again.";

  // Server errors
  static const String serverError = "Server error. Please try again later.";
  static const String serviceUnavailableError =
      "Service temporarily unavailable. Please try again later.";
  static const String internalServerError =
      "Internal server error. Please try again later.";

  // Validation errors
  static const String validationError =
      "Invalid input. Please check your data.";
  static const String invalidEmailError = "Please enter a valid email address.";
  static const String weakPasswordError = "Please use a stronger password.";
  static const String passwordMismatchError = "Passwords do not match.";

  // General errors
  static const String unexpectedError =
      "Something went wrong. Please try again.";
  static const String unknownError =
      "An unexpected error occurred. Please try again.";

  // Permission errors
  static const String permissionDeniedError =
      "Permission denied. Please grant required permissions.";
  static const String locationPermissionError =
      "Location permission denied. Please grant permission.";
  static const String cameraPermissionError =
      "Camera permission denied. Please grant permission.";
}
