import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_models.dart';
import '../models/login_response_model.dart';

abstract class AuthDataSource {
  Future<SignupResponse> signup(SignupRequest request);
  Future<void> forgotPassword(String email);
  Future<void> verifyOtp(String email, String otp);
  Future<Map<String, dynamic>> sendVerificationCode({
    required String userId,
    required String type,
  });
  Future<Map<String, dynamic>> verifyCode({
    required String userId,
    required String code,
  });
  Future<LoginResponseModel> login({
    required String email,
    required String phoneNumber,
    required String password,
  });
  Future<Map<String, dynamic>> sendForgotCode({
    required String email,
    required String phoneNumber,
  });
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String phoneNumber,
    required String code,
    required String newPassword,
  });
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiClient _apiClient;

  AuthDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<SignupResponse> signup(SignupRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.signupEndpoint,
      body: request.toJson(),
    );

    if (response.isSuccess) {
      return SignupResponse.fromJson(response.data);
    } else {
      throw Exception(response.error ?? 'Signup failed');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await _apiClient.post(
      ApiConstants.forgotPasswordEndpoint,
      body: {'email': email},
    );

    if (!response.isSuccess) {
      throw Exception(response.error ?? 'Forgot password failed');
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    final response = await _apiClient.post(
      ApiConstants.verifyOtpEndpoint,
      body: {'email': email, 'otp': otp},
    );

    if (!response.isSuccess) {
      throw Exception(response.error ?? 'OTP verification failed');
    }
  }

  @override
  Future<Map<String, dynamic>> sendVerificationCode({
    required String userId,
    required String type,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.sendVerificationCodeEndpoint,
      body: {'userId': userId, 'type': type},
    );

    if (response.isSuccess) {
      return response.data;
    } else {
      throw Exception(response.error ?? 'Send verification code failed');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyCode({
    required String userId,
    required String code,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.verifyCodeEndpoint,
      body: {'userId': userId, 'code': code},
    );

    if (response.isSuccess) {
      return response.data;
    } else {
      throw Exception(response.error ?? 'Code verification failed');
    }
  }

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // Determine if email or phone should be used based on email format
    final bool isEmail = email.contains('@');

    final Map<String, dynamic> requestBody = {'pass': password};

    if (isEmail) {
      requestBody['email'] = email;
    } else {
      requestBody['phoneNumber'] = phoneNumber;
    }

    final response = await _apiClient.post(
      '/api/v1/auth/login',
      body: requestBody,
    );

    if (response.isSuccess) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      throw Exception(response.error ?? 'Login failed');
    }
  }

  @override
  Future<Map<String, dynamic>> sendForgotCode({
    required String email,
    required String phoneNumber,
  }) async {
    // Determine if email or phone should be used based on email format
    final bool isEmail = email.contains('@');

    final Map<String, dynamic> requestBody = {};

    if (isEmail) {
      requestBody['email'] = email;
    } else {
      requestBody['phoneNumber'] = phoneNumber;
    }

    final response = await _apiClient.post(
      ApiConstants.sendForgotCodeEndpoint,
      body: requestBody,
    );

    if (response.isSuccess) {
      return response.data;
    } else {
      throw Exception(response.error ?? 'Send forgot code failed');
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String phoneNumber,
    required String code,
    required String newPassword,
  }) async {
    print('🔍 DEBUG: AuthDataSource resetPassword called');
    print('🔍 DEBUG: Email: $email');
    print('🔍 DEBUG: PhoneNumber: $phoneNumber');
    print('🔍 DEBUG: Code: $code');
    print('🔍 DEBUG: NewPassword: $newPassword');

    // Determine if email or phone should be used based on email format
    final bool isEmail = email.contains('@');
    print('🔍 DEBUG: Is Email: $isEmail');

    final Map<String, dynamic> requestBody = {
      'code': code,
      'newPassword': newPassword,
    };

    if (isEmail) {
      requestBody['email'] = email;
    } else {
      requestBody['phoneNumber'] = phoneNumber;
    }

    print('🔍 DEBUG: Request Body: $requestBody');

    final response = await _apiClient.post(
      ApiConstants.resetPasswordEndpoint,
      body: requestBody,
    );

    if (response.isSuccess) {
      return response.data;
    } else {
      throw Exception(response.error ?? 'Reset password failed');
    }
  }
}
