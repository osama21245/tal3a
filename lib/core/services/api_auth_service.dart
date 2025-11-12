import 'package:tal3a/core/services/auth_service.dart';
import 'package:tal3a/core/constants/api_constants.dart';

class ApiAuthService {
  static final ApiAuthService _instance = ApiAuthService._internal();
  factory ApiAuthService() => _instance;
  ApiAuthService._internal();

  final AuthService _authService = AuthService();

  // Get authenticated headers with current user's token
  Future<Map<String, String>> getAuthenticatedHeaders() async {
    try {
      final accessToken = await _authService.getAccessToken();

      if (accessToken == null) {
        throw Exception('No access token available');
      }

      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
    } catch (e) {
      print('🔍 ApiAuthService: Error getting authenticated headers: $e');
      // Fallback to default headers without auth
      return ApiConstants.defaultHeaders;
    }
  }

  // Get authenticated headers with token refresh on 498 error
  Future<Map<String, String>> getAuthenticatedHeadersWithRefresh() async {
    try {
      final accessToken = await _authService.getAccessToken();

      if (accessToken == null) {
        throw Exception('No access token available');
      }

      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
    } catch (e) {
      print('🔍 ApiAuthService: Error getting authenticated headers: $e');
      // Try to refresh token
      try {
        final newToken = await _authService.refreshAccessToken();
        if (newToken != null) {
          return {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $newToken',
          };
        }
      } catch (refreshError) {
        print('🔍 ApiAuthService: Token refresh failed: $refreshError');
      }

      // Fallback to default headers without auth
      return ApiConstants.defaultHeaders;
    }
  }

  // Handle 498 error by refreshing token and retrying
  Future<Map<String, String>?> handleTokenExpired() async {
    try {
      print('🔍 ApiAuthService: Handling token expired, attempting refresh');
      final newToken = await _authService.refreshAccessToken();

      if (newToken != null) {
        print('🔍 ApiAuthService: Token refreshed successfully');
        return {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $newToken',
        };
      } else {
        print('🔍 ApiAuthService: Token refresh failed');
        return null;
      }
    } catch (e) {
      print('🔍 ApiAuthService: Error refreshing token: $e');
      return null;
    }
  }
}
