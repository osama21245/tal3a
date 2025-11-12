import 'dart:async' as async;
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/app_exceptions.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import 'package:tal3a/core/exceptions/error_constants.dart';

// Execute try and catch for repository layer with Either pattern
Future<Either<Failure, T>> executeTryAndCatchForRepository<T>(
  Future<T> Function() action,
) async {
  try {
    final result = await action();
    return right(result);
  } on NetworkException catch (e) {
    return left(NetworkFailure(e.message));
  } on AuthenticationException catch (e) {
    return left(AuthenticationFailure(e.message));
  } on ValidationException catch (e) {
    return left(ValidationFailure(e.message));
  } on async.TimeoutException catch (e) {
    return left(TimeoutFailure(e.message ?? 'Request timed out'));
  } on ServerException catch (e) {
    return left(ServerFailure(e.message));
  } on SocketException {
    return left(NetworkFailure(ErrorConstants.noInternetError));
  } on FormatException {
    return left(Failure(ErrorConstants.unexpectedError));
  } on HttpException catch (e) {
    return left(ServerFailure('HTTP error: ${e.message}'));
  } catch (e) {
    // Check for specific error patterns
    if (e.toString().contains('network') ||
        e.toString().contains('connection') ||
        e.toString().contains('timeout')) {
      return left(NetworkFailure(ErrorConstants.networkError));
    }

    if (e.toString().contains('401') ||
        e.toString().contains('unauthorized') ||
        e.toString().contains('authentication')) {
      return left(AuthenticationFailure(ErrorConstants.authenticationError));
    }

    if (e.toString().contains('498') ||
        e.toString().contains('token expired')) {
      return left(AuthenticationFailure(ErrorConstants.tokenExpiredError));
    }

    if (e.toString().contains('400') ||
        e.toString().contains('validation') ||
        e.toString().contains('invalid')) {
      return left(ValidationFailure(ErrorConstants.validationError));
    }

    if (e.toString().contains('500') ||
        e.toString().contains('502') ||
        e.toString().contains('503') ||
        e.toString().contains('504')) {
      return left(ServerFailure(ErrorConstants.serverError));
    }

    print('🔍 Unhandled exception: ${e.toString()}');
    return left(Failure(ErrorConstants.unexpectedError));
  }
}

// Execute try and catch for data layer (throws exceptions)
Future<T> executeTryAndCatchForDataLayer<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on NetworkException {
    rethrow;
  } on AuthenticationException {
    rethrow;
  } on ValidationException {
    rethrow;
  } on async.TimeoutException {
    rethrow;
  } on ServerException {
    rethrow;
  } on SocketException {
    throw NetworkException(ErrorConstants.noInternetError);
  } on FormatException {
    throw ServerException(message: ErrorConstants.unexpectedError);
  } on HttpException catch (e) {
    throw ServerException(message: 'HTTP error: ${e.message}');
  } catch (e) {
    // Check for specific error patterns and convert to appropriate exceptions
    if (e.toString().contains('network') ||
        e.toString().contains('connection') ||
        e.toString().contains('timeout')) {
      throw NetworkException(ErrorConstants.networkError);
    }

    if (e.toString().contains('401') ||
        e.toString().contains('unauthorized') ||
        e.toString().contains('authentication')) {
      throw AuthenticationException(ErrorConstants.authenticationError);
    }

    if (e.toString().contains('498') ||
        e.toString().contains('token expired')) {
      throw AuthenticationException(ErrorConstants.tokenExpiredError);
    }

    if (e.toString().contains('400') ||
        e.toString().contains('validation') ||
        e.toString().contains('invalid')) {
      throw ValidationException(ErrorConstants.validationError);
    }

    if (e.toString().contains('500') ||
        e.toString().contains('502') ||
        e.toString().contains('503') ||
        e.toString().contains('504')) {
      throw ServerException(message: ErrorConstants.serverError);
    }

    print('🔍 Unhandled exception in data layer: ${e.toString()}');
    throw ServerException(message: ErrorConstants.unexpectedError);
  }
}

// Helper function to convert HTTP status codes to appropriate exceptions
void handleHttpStatusCode(int statusCode, String responseBody) {
  switch (statusCode) {
    case 400:
      throw ValidationException('Invalid request. Please check your input.');
    case 401:
      throw AuthenticationException('Unauthorized. Please login again.');
    case 403:
      throw AuthenticationException(
        'Access denied. You don\'t have permission for this action.',
      );
    case 404:
      throw ServerException(message: 'Resource not found.');
    case 498:
      throw AuthenticationException('Session expired. Please login again.');
    case 500:
      throw ServerException(
        message: 'Internal server error. Please try again later.',
      );
    case 502:
    case 503:
    case 504:
      throw ServerException(
        message: 'Service temporarily unavailable. Please try again later.',
      );
    default:
      throw ServerException(
        message: 'An unexpected error occurred. Please try again.',
      );
  }
}
