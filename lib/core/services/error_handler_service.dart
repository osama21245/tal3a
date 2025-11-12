import 'package:flutter/material.dart';
import 'package:tal3a/core/services/auth_service.dart';

enum ErrorType {
  networkError,
  authenticationError,
  tokenExpired,
  serverError,
  validationError,
  unknownError,
}

class AppError {
  final ErrorType type;
  final String message;
  final String? details;
  final int? statusCode;
  final bool isRetryable;

  AppError({
    required this.type,
    required this.message,
    this.details,
    this.statusCode,
    this.isRetryable = false,
  });

  factory AppError.fromHttpResponse(int statusCode, String responseBody) {
    switch (statusCode) {
      case 400:
        return AppError(
          type: ErrorType.validationError,
          message: 'Invalid request. Please check your input.',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: false,
        );
      case 401:
        return AppError(
          type: ErrorType.authenticationError,
          message: 'Authentication failed. Please login again.',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: false,
        );
      case 403:
        return AppError(
          type: ErrorType.authenticationError,
          message: 'Access denied. You don\'t have permission for this action.',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: false,
        );
      case 404:
        return AppError(
          type: ErrorType.serverError,
          message: 'Resource not found.',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: false,
        );
      case 498:
        return AppError(
          type: ErrorType.tokenExpired,
          message: 'Session expired. Refreshing...',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: true,
        );
      case 500:
        return AppError(
          type: ErrorType.serverError,
          message: 'Server error. Please try again later.',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: true,
        );
      case 502:
      case 503:
      case 504:
        return AppError(
          type: ErrorType.serverError,
          message: 'Service temporarily unavailable. Please try again later.',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: true,
        );
      default:
        return AppError(
          type: ErrorType.unknownError,
          message: 'An unexpected error occurred. Please try again.',
          details: responseBody,
          statusCode: statusCode,
          isRetryable: true,
        );
    }
  }

  factory AppError.fromException(dynamic exception) {
    if (exception.toString().contains('SocketException') ||
        exception.toString().contains('No internet connection')) {
      return AppError(
        type: ErrorType.networkError,
        message:
            'No internet connection. Please check your network and try again.',
        details: exception.toString(),
        isRetryable: true,
      );
    } else if (exception.toString().contains('TimeoutException')) {
      return AppError(
        type: ErrorType.networkError,
        message: 'Request timeout. Please try again.',
        details: exception.toString(),
        isRetryable: true,
      );
    } else {
      return AppError(
        type: ErrorType.unknownError,
        message: 'An unexpected error occurred. Please try again.',
        details: exception.toString(),
        isRetryable: true,
      );
    }
  }
}

class ErrorHandlerService {
  static final ErrorHandlerService _instance = ErrorHandlerService._internal();
  factory ErrorHandlerService() => _instance;
  ErrorHandlerService._internal();

  final AuthService _authService = AuthService();

  // Handle error and show appropriate message to user
  Future<void> handleError(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
    VoidCallback? onLogout,
  }) async {
    print('🔍 ErrorHandlerService: Handling error - ${error.type}');
    print('🔍 Error message: ${error.message}');
    print('🔍 Error details: ${error.details}');

    // Handle token expired error specially
    if (error.type == ErrorType.tokenExpired) {
      await _handleTokenExpired(context, onLogout);
      return;
    }

    // Handle authentication errors
    if (error.type == ErrorType.authenticationError) {
      await _handleAuthenticationError(context, onLogout);
      return;
    }

    // Show error message to user
    _showErrorSnackBar(context, error, onRetry);
  }

  // Handle token expired by refreshing token
  Future<void> _handleTokenExpired(
    BuildContext context,
    VoidCallback? onLogout,
  ) async {
    try {
      print('🔍 ErrorHandlerService: Token expired, attempting refresh');

      // Show loading message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Session expired. Refreshing...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Attempt to refresh token
      final newToken = await _authService.refreshAccessToken();

      if (newToken != null) {
        print('🔍 ErrorHandlerService: Token refreshed successfully');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Session refreshed successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('🔍 ErrorHandlerService: Token refresh failed');
        await _handleAuthenticationError(context, onLogout);
      }
    } catch (e) {
      print('🔍 ErrorHandlerService: Error refreshing token: $e');
      await _handleAuthenticationError(context, onLogout);
    }
  }

  // Handle authentication errors by logging out user
  Future<void> _handleAuthenticationError(
    BuildContext context,
    VoidCallback? onLogout,
  ) async {
    print('🔍 ErrorHandlerService: Handling authentication error');

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('Authentication failed. Please login again.')),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    // Call logout callback if provided
    if (onLogout != null) {
      await Future.delayed(const Duration(seconds: 1));
      onLogout();
    }
  }

  // Show error snackbar with retry option
  void _showErrorSnackBar(
    BuildContext context,
    AppError error,
    VoidCallback? onRetry,
  ) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(_getErrorIcon(error.type), color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(error.message)),
        ],
      ),
      backgroundColor: _getErrorColor(error.type),
      duration: Duration(seconds: error.isRetryable ? 5 : 3),
      action:
          error.isRetryable && onRetry != null
              ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
              : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Get appropriate icon for error type
  IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.networkError:
        return Icons.wifi_off;
      case ErrorType.authenticationError:
        return Icons.lock;
      case ErrorType.tokenExpired:
        return Icons.refresh;
      case ErrorType.serverError:
        return Icons.error;
      case ErrorType.validationError:
        return Icons.warning;
      case ErrorType.unknownError:
        return Icons.help_outline;
    }
  }

  // Get appropriate color for error type
  Color _getErrorColor(ErrorType type) {
    switch (type) {
      case ErrorType.networkError:
        return Colors.orange;
      case ErrorType.authenticationError:
        return Colors.red;
      case ErrorType.tokenExpired:
        return Colors.blue;
      case ErrorType.serverError:
        return Colors.red;
      case ErrorType.validationError:
        return Colors.amber;
      case ErrorType.unknownError:
        return Colors.grey;
    }
  }

  // Handle API response and return appropriate error
  AppError handleApiResponse(int statusCode, String responseBody) {
    return AppError.fromHttpResponse(statusCode, responseBody);
  }

  // Handle exception and return appropriate error
  AppError handleException(dynamic exception) {
    return AppError.fromException(exception);
  }
}
