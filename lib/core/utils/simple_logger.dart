import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class SimpleLogger {
  static void logRequest(
    String method,
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '🚀 REQUEST [$timestamp]: $method $url';

    if (kDebugMode) {
      print(logMessage);
      if (body != null) print('📦 BODY: $body');
      if (headers != null) print('📋 HEADERS: $headers');
    }
  }

  static void logResponse(
    String method,
    String url,
    int statusCode, {
    dynamic body,
    Duration? duration,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    final durationStr =
        duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    final logMessage =
        '$emoji RESPONSE [$timestamp]: $method $url - $statusCode$durationStr';

    if (kDebugMode) {
      print(logMessage);
      if (body != null) print('📦 RESPONSE BODY: $body');
    }
  }

  static void logError(
    String method,
    String url,
    String error, {
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '💥 ERROR [$timestamp]: $method $url - $error';

    if (kDebugMode) {
      print(logMessage);
      if (stackTrace != null) print('📋 STACK TRACE: $stackTrace');
    }
  }

  static void logInfo(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag] ' : '';
    final logMessage = 'ℹ️ INFO [$timestamp]: $tagStr$message';

    if (kDebugMode) {
      print(logMessage);
    }
  }

  static void logWarning(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag] ' : '';
    final logMessage = '⚠️ WARNING [$timestamp]: $tagStr$message';

    if (kDebugMode) {
      print(logMessage);
    }
  }

  static void logSuccess(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag] ' : '';
    final logMessage = '✅ SUCCESS [$timestamp]: $tagStr$message';

    if (kDebugMode) {
      print(logMessage);
    }
  }
}
