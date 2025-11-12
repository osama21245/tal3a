import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constants/api_constants.dart';
import '../utils/simple_logger.dart';
import '../services/api_auth_service.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/try_and_catch.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();
  final ApiAuthService _apiAuthService = ApiAuthService();

  // Authenticated GET Request with automatic token refresh
  Future<ApiResponse> getAuthenticated(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    // First attempt with current token
    final headers = await _apiAuthService.getAuthenticatedHeaders();
    final response = await get(
      endpoint,
      headers: headers,
      queryParams: queryParams,
    );

    // Handle different status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else if (response.statusCode == 498) {
      print('🔍 ApiClient: Token expired, attempting refresh and retry');
      final newHeaders = await _apiAuthService.handleTokenExpired();
      if (newHeaders != null) {
        final retryResponse = await get(
          endpoint,
          headers: newHeaders,
          queryParams: queryParams,
        );
        if (retryResponse.statusCode == 498) {
          throw AuthenticationException('Session expired. Please login again.');
        }
        return retryResponse;
      } else {
        throw AuthenticationException('Session expired. Please login again.');
      }
    } else {
      // Handle other HTTP status codes
      handleHttpStatusCode(response.statusCode, response.error ?? '');
      return response; // This line won't be reached due to exception above
    }
  }

  // Authenticated POST Request with automatic token refresh
  Future<ApiResponse> postAuthenticated(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    // First attempt with current token
    final headers = await _apiAuthService.getAuthenticatedHeaders();
    final response = await post(
      endpoint,
      body: body,
      headers: headers,
      queryParams: queryParams,
    );

    // Handle different status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else if (response.statusCode == 498) {
      print('🔍 ApiClient: Token expired, attempting refresh and retry');
      final newHeaders = await _apiAuthService.handleTokenExpired();
      if (newHeaders != null) {
        final retryResponse = await post(
          endpoint,
          body: body,
          headers: newHeaders,
          queryParams: queryParams,
        );
        if (retryResponse.statusCode == 498) {
          throw AuthenticationException('Session expired. Please login again.');
        }
        return retryResponse;
      } else {
        throw AuthenticationException('Session expired. Please login again.');
      }
    } else {
      // Handle other HTTP status codes
      handleHttpStatusCode(response.statusCode, response.error ?? '');
      return response; // This line won't be reached due to exception above
    }
  }

  // Authenticated DELETE Request with automatic token refresh
  Future<ApiResponse> deleteAuthenticated(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    // First attempt with current token
    final headers = await _apiAuthService.getAuthenticatedHeaders();
    final response = await delete(
      endpoint,
      headers: headers,
      queryParams: queryParams,
    );

    // Handle different status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else if (response.statusCode == 498) {
      print('🔍 ApiClient: Token expired, attempting refresh and retry');
      final newHeaders = await _apiAuthService.handleTokenExpired();
      if (newHeaders != null) {
        final retryResponse = await delete(
          endpoint,
          headers: newHeaders,
          queryParams: queryParams,
        );
        if (retryResponse.statusCode == 498) {
          throw AuthenticationException('Session expired. Please login again.');
        }
        return retryResponse;
      } else {
        throw AuthenticationException('Session expired. Please login again.');
      }
    } else {
      // Handle other HTTP status codes
      handleHttpStatusCode(response.statusCode, response.error ?? '');
      return response; // This line won't be reached due to exception above
    }
  }

  // Authenticated Multipart Upload with automatic token refresh
  Future<ApiResponse> uploadMultipartAuthenticated(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, File> files,
    Map<String, String>? queryParams,
  }) async {
    // First attempt with current token
    final headers = await _apiAuthService.getAuthenticatedHeaders();
    // Remove Content-Type header for multipart requests
    headers.remove('Content-Type');

    final response = await uploadMultipart(
      endpoint,
      fields: fields,
      files: files,
      headers: headers,
      queryParams: queryParams,
    );

    // Handle different status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else if (response.statusCode == 498) {
      print('🔍 ApiClient: Token expired, attempting refresh and retry');
      final newHeaders = await _apiAuthService.handleTokenExpired();
      if (newHeaders != null) {
        // Remove Content-Type header for multipart requests
        newHeaders.remove('Content-Type');
        final retryResponse = await uploadMultipart(
          endpoint,
          fields: fields,
          files: files,
          headers: newHeaders,
          queryParams: queryParams,
        );
        if (retryResponse.statusCode == 498) {
          throw AuthenticationException('Session expired. Please login again.');
        }
        return retryResponse;
      } else {
        throw AuthenticationException('Session expired. Please login again.');
      }
    } else {
      // Handle other HTTP status codes
      handleHttpStatusCode(response.statusCode, response.error ?? '');
      return response; // This line won't be reached due to exception above
    }
  }

  // GET Request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final startTime = DateTime.now();
    final uri = _buildUri(endpoint, queryParams);
    final finalHeaders = {...ApiConstants.defaultHeaders, ...?headers};

    // Log request
    SimpleLogger.logRequest('GET', uri.toString(), headers: finalHeaders);

    try {
      final response = await _client
          .get(uri, headers: finalHeaders)
          .timeout(ApiConstants.timeoutDuration);

      final duration = DateTime.now().difference(startTime);

      // Log response
      SimpleLogger.logResponse(
        'GET',
        uri.toString(),
        response.statusCode,
        body: response.body,
        duration: duration,
      );

      return _handleResponse(response);
    } catch (e) {
      SimpleLogger.logError('GET', uri.toString(), e.toString());
      return ApiResponse.error(_handleError(e));
    }
  }

  // POST Request
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final startTime = DateTime.now();
    final uri = _buildUri(endpoint, queryParams);
    final finalHeaders = {...ApiConstants.defaultHeaders, ...?headers};

    // Log request
    SimpleLogger.logRequest(
      'POST',
      uri.toString(),
      body: body,
      headers: finalHeaders,
    );

    try {
      final response = await _client
          .post(
            uri,
            headers: finalHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.timeoutDuration);

      final duration = DateTime.now().difference(startTime);

      // Log response
      SimpleLogger.logResponse(
        'POST',
        uri.toString(),
        response.statusCode,
        body: response.body,
        duration: duration,
      );

      return _handleResponse(response);
    } catch (e) {
      SimpleLogger.logError('POST', uri.toString(), e.toString());
      return ApiResponse.error(_handleError(e));
    }
  }

  // PUT Request
  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _client
          .put(
            uri,
            headers: {...ApiConstants.defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // DELETE Request
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _client
          .delete(uri, headers: {...ApiConstants.defaultHeaders, ...?headers})
          .timeout(ApiConstants.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // Multipart Upload Request
  Future<ApiResponse> uploadMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, File> files,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final startTime = DateTime.now();
    final uri = _buildUri(endpoint, queryParams);
    final finalHeaders = {...ApiConstants.authenticatedHeaders, ...?headers};

    // Remove Content-Type header for multipart requests
    finalHeaders.remove('Content-Type');

    // Log request
    SimpleLogger.logRequest(
      'POST',
      uri.toString(),
      headers: finalHeaders,
      body: {'files_count': files.length, 'fields': fields},
    );

    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(finalHeaders);

      // Add fields
      request.fields.addAll(fields);

      // Add files
      for (final entry in files.entries) {
        final file = entry.value;
        final fieldName = entry.key;

        if (await file.exists()) {
          final fileStream = http.ByteStream(file.openRead());
          final fileLength = await file.length();
          final multipartFile = http.MultipartFile(
            fieldName,
            fileStream,
            fileLength,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'jpeg'), // Default to JPEG
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send().timeout(
        ApiConstants.timeoutDuration,
      );
      final response = await http.Response.fromStream(streamedResponse);

      final duration = DateTime.now().difference(startTime);

      // Log response
      SimpleLogger.logResponse(
        'POST',
        uri.toString(),
        response.statusCode,
        body: response.body,
        duration: duration,
      );

      return _handleResponse(response);
    } catch (e) {
      SimpleLogger.logError('POST', uri.toString(), e.toString());
      return ApiResponse.error(_handleError(e));
    }
  }

  // Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, String>? queryParams) {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  // Handle HTTP Response
  ApiResponse _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(data, response.statusCode);
      } else {
        return ApiResponse.error(
          data['message'] ??
              'Request failed with status ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Failed to parse response: $e',
        response.statusCode,
      );
    }
  }

  // Handle Errors
  String _handleError(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection';
    } else if (error is HttpException) {
      return 'HTTP error occurred';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout';
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }

  // Dispose client
  void dispose() {
    _client.close();
  }
}

// API Response Model
class ApiResponse {
  final bool isSuccess;
  final dynamic data;
  final String? error;
  final int statusCode;

  ApiResponse._({
    required this.isSuccess,
    this.data,
    this.error,
    required this.statusCode,
  });

  factory ApiResponse.success(dynamic data, int statusCode) {
    return ApiResponse._(isSuccess: true, data: data, statusCode: statusCode);
  }

  factory ApiResponse.error(String error, [int? statusCode]) {
    return ApiResponse._(
      isSuccess: false,
      error: error,
      statusCode: statusCode ?? 0,
    );
  }
}
