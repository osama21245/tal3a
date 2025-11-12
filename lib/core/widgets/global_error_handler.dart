import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/services/error_handler_service.dart';
import 'package:tal3a/core/controller/user_controller.dart';

class GlobalErrorHandler extends StatelessWidget {
  final Widget child;

  const GlobalErrorHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserController, UserControllerState>(
      listener: (context, state) {
        if (state.isError) {
          final errorHandler = ErrorHandlerService();
          final error = errorHandler.handleException(state.error);

          errorHandler.handleError(
            context,
            error,
            onLogout: () {
              context.read<UserController>().handleAuthenticationError();
            },
          );
        }
      },
      child: child,
    );
  }
}

// Extension to easily handle errors in widgets
extension ErrorHandlingExtension on BuildContext {
  void handleApiError(
    int statusCode,
    String responseBody, {
    VoidCallback? onRetry,
  }) {
    final errorHandler = ErrorHandlerService();
    final error = errorHandler.handleApiResponse(statusCode, responseBody);

    errorHandler.handleError(
      this,
      error,
      onRetry: onRetry,
      onLogout: () {
        read<UserController>().handleAuthenticationError();
      },
    );
  }

  void handleException(dynamic exception, {VoidCallback? onRetry}) {
    final errorHandler = ErrorHandlerService();
    final error = errorHandler.handleException(exception);

    errorHandler.handleError(
      this,
      error,
      onRetry: onRetry,
      onLogout: () {
        read<UserController>().handleAuthenticationError();
      },
    );
  }
}
