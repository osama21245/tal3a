import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/models/user_info_response_model.dart';
import '../../features/auth/data/models/refresh_token_response_model.dart';
import '../../features/auth/data/models/profile_setup_request_model.dart';

class AuthService {
  static const String _userDataKey = 'user_data';
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataExpiryKey = 'user_data_expiry';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _profileSetupCompletedKey = 'profile_setup_completed';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Cache user data with expiry (1 day)
  Future<void> cacheUserData(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      final expiryTime =
          DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch;

      await _storage.write(key: _userDataKey, value: userJson);
      await _storage.write(key: _tokenKey, value: user.token);
      await _storage.write(key: _refreshTokenKey, value: user.refreshToken);
      await _storage.write(
        key: _userDataExpiryKey,
        value: expiryTime.toString(),
      );
      await _storage.write(key: _isLoggedInKey, value: 'true');
    } catch (e) {
      throw Exception('Failed to cache user data: $e');
    }
  }

  // Get cached user data
  Future<UserModel?> getCachedUserData() async {
    try {
      final userJson = await _storage.read(key: _userDataKey);
      final expiryTimeStr = await _storage.read(key: _userDataExpiryKey);

      if (userJson == null || expiryTimeStr == null) {
        return null;
      }

      final expiryTime = int.parse(expiryTimeStr);
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if data is expired
      if (now > expiryTime) {
        await clearUserData();
        return null;
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      await clearUserData();
      return null;
    }
  }

  // Get current access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get current refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final isLoggedIn = await _storage.read(key: _isLoggedInKey);
    return isLoggedIn == 'true';
  }

  // Check if profile setup is completed
  Future<bool> isProfileSetupCompleted() async {
    final isCompleted = await _storage.read(key: _profileSetupCompletedKey);
    return isCompleted == 'true';
  }

  // Mark profile setup as completed
  Future<void> markProfileSetupCompleted() async {
    await _storage.write(key: _profileSetupCompletedKey, value: 'true');

    // Also update the cached user data to mark profile as completed
    final user = await getCachedUserData();
    if (user != null) {
      final updatedUser = user.copyWith(profileCompletion: true);
      await cacheUserData(updatedUser);
    }
  }

  // Refresh access token
  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      print(
        '🔍 AuthService: Refreshing access token with refresh token: $refreshToken',
      );

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.refreshTokenEndpoint}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      print(
        '🔍 AuthService: Refresh token response status: ${response.statusCode}',
      );
      print('🔍 AuthService: Refresh token response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final refreshResponse = RefreshTokenResponseModel.fromJson(
          responseData,
        );

        // Update tokens in storage
        await _storage.write(
          key: _tokenKey,
          value: refreshResponse.accessToken,
        );
        await _storage.write(
          key: _refreshTokenKey,
          value: refreshResponse.newRefreshToken,
        );

        return refreshResponse.accessToken;
      } else {
        throw Exception('Failed to refresh token: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  // Get user info from server
  Future<UserModel> getUserInfo() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getUserInfoEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userInfoResponse = UserInfoResponseModel.fromJson(responseData);

        // Cache the updated user data
        await cacheUserData(userInfoResponse.data);

        return userInfoResponse.data;
      } else if (response.statusCode == 498) {
        // Token expired, try to refresh
        final newToken = await refreshAccessToken();
        if (newToken != null) {
          // Retry with new token
          return await getUserInfo();
        } else {
          throw Exception('Failed to refresh token');
        }
      } else {
        throw Exception('Failed to get user info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }

  // Complete profile setup
  Future<void> completeProfileSetup(ProfileSetupRequestModel request) async {
    try {
      print('🔍 AuthService: Starting profile setup API call');
      print('🔍 Request data: ${request.toJson()}');

      final accessToken = await getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      print('🔍 Using access token: ${accessToken.substring(0, 20)}...');

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.profileSetupEndpoint}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(request.toJson()),
      );

      print('🔍 API Response status: ${response.statusCode}');
      print('🔍 API Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('🔍 Profile setup API call successful');
        await markProfileSetupCompleted();
      } else if (response.statusCode == 498) {
        print('🔍 Token expired, attempting refresh');
        // Token expired, try to refresh
        final newToken = await refreshAccessToken();
        if (newToken != null) {
          // Retry with new token
          await completeProfileSetup(request);
        } else {
          throw Exception('Failed to refresh token');
        }
      } else {
        throw Exception(
          'Failed to complete profile setup: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('🔍 AuthService error: $e');
      throw Exception('Failed to complete profile setup: $e');
    }
  }

  // Get authenticated headers for API calls
  Future<Map<String, String>> getAuthenticatedHeaders() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception('No access token available');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  // Clear all user data
  Future<void> clearUserData() async {
    await _storage.delete(key: _userDataKey);
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userDataExpiryKey);
    await _storage.delete(key: _isLoggedInKey);
    await _storage.delete(key: _profileSetupCompletedKey);
  }

  Future<void> clearAccessToken() async {
    return await _storage.write(key: _tokenKey, value: "asdasda");
  }

  // Logout
  Future<void> logout() async {
    await clearUserData();
  }
}
