import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_models.dart';
import '../../data/models/login_response_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/simple_logger.dart';

// Auth Status Enum
enum AuthStatus {
  initial,
  login,
  signup,
  signupLoading,
  signupSuccess,
  signupError,
  verificationLoading,
  verificationSuccess,
  verificationError,
  codeVerificationLoading,
  codeVerificationSuccess,
  codeVerificationError,
  loginLoading,
  loginSuccess,
  loginError,
  forgotCodeLoading,
  forgotCodeSuccess,
  forgotCodeError,
  resetPasswordLoading,
  resetPasswordSuccess,
  resetPasswordError,
}

// Extension for easy state checking
extension AuthStateExtension on AuthState {
  bool get isInitial => status == AuthStatus.initial;
  bool get isLogin => status == AuthStatus.login;
  bool get isSignup => status == AuthStatus.signup;
  bool get isSignupLoading => status == AuthStatus.signupLoading;
  bool get isSignupSuccess => status == AuthStatus.signupSuccess;
  bool get isSignupError => status == AuthStatus.signupError;
  bool get isVerificationLoading => status == AuthStatus.verificationLoading;
  bool get isVerificationSuccess => status == AuthStatus.verificationSuccess;
  bool get isVerificationError => status == AuthStatus.verificationError;
  bool get isCodeVerificationLoading =>
      status == AuthStatus.codeVerificationLoading;
  bool get isCodeVerificationSuccess =>
      status == AuthStatus.codeVerificationSuccess;
  bool get isCodeVerificationError =>
      status == AuthStatus.codeVerificationError;
  bool get isLoginLoading => status == AuthStatus.loginLoading;
  bool get isLoginSuccess => status == AuthStatus.loginSuccess;
  bool get isLoginError => status == AuthStatus.loginError;
  bool get isForgotCodeLoading => status == AuthStatus.forgotCodeLoading;
  bool get isForgotCodeSuccess => status == AuthStatus.forgotCodeSuccess;
  bool get isForgotCodeError => status == AuthStatus.forgotCodeError;
  bool get isResetPasswordLoading => status == AuthStatus.resetPasswordLoading;
  bool get isResetPasswordSuccess => status == AuthStatus.resetPasswordSuccess;
  bool get isResetPasswordError => status == AuthStatus.resetPasswordError;
}

// Auth State Class
class AuthState {
  final AuthStatus status;
  final String? error;
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  final SignupResponse? signupResponse;
  final LoginResponseModel? loginResponse;
  final String backgroundImage;

  AuthState({
    this.status = AuthStatus.initial,
    this.error,
    this.email,
    this.phoneNumber,
    this.fullName,
    this.signupResponse,
    this.loginResponse,
    this.backgroundImage = 'assets/images/signin_background.png',
  });

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    String? email,
    String? phoneNumber,
    String? fullName,
    SignupResponse? signupResponse,
    LoginResponseModel? loginResponse,
    String? backgroundImage,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      signupResponse: signupResponse ?? this.signupResponse,
      loginResponse: loginResponse ?? this.loginResponse,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }

  @override
  String toString() =>
      'AuthState(status: $status, error: $error, email: $email, phoneNumber: $phoneNumber, fullName: $fullName)';
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthState()) {
    print('🔍 DEBUG: AuthCubit constructor called - creating new instance');
  }

  void switchToLogin() {
    emit(
      state.copyWith(
        status: AuthStatus.login,
        backgroundImage: 'assets/images/signin_background.png',
        // Keep existing user data
        email: state.email,
        phoneNumber: state.phoneNumber,
        fullName: state.fullName,
      ),
    );
  }

  void switchToSignup() {
    emit(
      state.copyWith(
        status: AuthStatus.signup,
        backgroundImage: 'assets/images/sign_up.png',
        // Keep existing user data
        email: state.email,
        phoneNumber: state.phoneNumber,
        fullName: state.fullName,
      ),
    );
  }

  // Signup method
  Future<void> signup({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // Log signup attempt
    SimpleLogger.logInfo('Signup attempt for email: $email', tag: 'AUTH');

    // Store user data and set loading
    emit(
      state.copyWith(
        status: AuthStatus.signupLoading,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        error: null,
      ),
    );

    try {
      final request = SignupRequest(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      final result = await _authRepository.signup(request);
      result.match(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.signupError,
              error: failure.message,
            ),
          );
        },
        (response) {
          SimpleLogger.logSuccess(
            'Signup successful for email: $email, userId: ${response.userId}',
            tag: 'AUTH',
          );
          emit(
            state.copyWith(
              status: AuthStatus.signupSuccess,
              signupResponse: response,
              error: null,
            ),
          );
          print(
            '🔍 DEBUG: AuthCubit signup success - state updated with email: ${state.email}, phone: ${state.phoneNumber}',
          );
        },
      );

      print(
        '🔍 DEBUG: AuthCubit signup success - state updated with email: ${state.email}, phone: ${state.phoneNumber}',
      );
    } catch (e) {
      // Log error
      print(e.toString());

      // Keep user data but set error status
      emit(state.copyWith(status: AuthStatus.signupError, error: e.toString()));
    }
  }

  bool get isLoginSelected {
    return state.isLogin ||
        state.isLoginLoading ||
        state.isLoginSuccess ||
        state.isLoginError;
  }

  bool get isSignupSelected {
    return state.isSignup ||
        state.isSignupLoading ||
        state.isSignupSuccess ||
        state.isSignupError;
  }

  bool get isSignupLoading {
    return state.isSignupLoading;
  }

  bool get isSignupSuccess {
    return state.isSignupSuccess;
  }

  bool get isSignupError {
    return state.isSignupError;
  }

  String get currentBackgroundImage {
    return state.backgroundImage;
  }

  // Getter methods for user data
  String? get currentEmail => state.email;
  String? get currentPhoneNumber => state.phoneNumber;
  String? get currentFullName => state.fullName;
  SignupResponse? get currentSignupResponse => state.signupResponse;

  // Method to preserve user data when navigating
  void preserveUserData() {
    if (state.email != null ||
        state.phoneNumber != null ||
        state.fullName != null) {
      // Data is already preserved, no need to do anything
      return;
    }
  }

  // Method to check if we have user data
  bool get hasUserData => state.email != null && state.phoneNumber != null;

  // Send verification code method
  Future<void> sendVerificationCode({required String type}) async {
    final userId = state.signupResponse?.userId;

    if (userId == null) {
      SimpleLogger.logError(
        'SEND_VERIFICATION',
        'No userId found',
        'User ID is null',
      );
      emit(
        state.copyWith(
          status: AuthStatus.verificationError,
          error: 'User ID not found. Please try signing up again.',
        ),
      );
      return;
    }

    SimpleLogger.logInfo(
      'Sending verification code for type: $type',
      tag: 'VERIFICATION',
    );

    emit(state.copyWith(status: AuthStatus.verificationLoading, error: null));

    try {
      final result = await _authRepository.sendVerificationCode(
        userId: userId,
        type: type,
      );
      result.match(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.verificationError,
              error: failure.message,
            ),
          );
        },
        (_) {
          SimpleLogger.logSuccess(
            'Verification code sent successfully',
            tag: 'VERIFICATION',
          );
          emit(
            state.copyWith(status: AuthStatus.verificationSuccess, error: null),
          );
        },
      );
    } catch (e) {
      SimpleLogger.logError(
        'SEND_VERIFICATION',
        'Exception occurred',
        e.toString(),
      );
      emit(
        state.copyWith(
          status: AuthStatus.verificationError,
          error: e.toString(),
        ),
      );
    }
  }

  // Verify code method
  Future<void> verifyCode({required String code}) async {
    final userId = state.signupResponse?.userId;

    if (userId == null) {
      SimpleLogger.logError(
        'VERIFY_CODE',
        'No userId found',
        'User ID is null',
      );
      emit(
        state.copyWith(
          status: AuthStatus.codeVerificationError,
          error: 'User ID not found. Please try signing up again.',
        ),
      );
      return;
    }

    SimpleLogger.logInfo('Verifying code: $code', tag: 'CODE_VERIFICATION');

    emit(
      state.copyWith(status: AuthStatus.codeVerificationLoading, error: null),
    );

    try {
      final result = await _authRepository.verifyCode(
        userId: userId,
        code: code,
      );
      result.match(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.codeVerificationError,
              error: failure.message,
            ),
          );
        },
        (_) {
          SimpleLogger.logSuccess(
            'Code verified successfully',
            tag: 'CODE_VERIFICATION',
          );
          emit(
            state.copyWith(
              status: AuthStatus.codeVerificationSuccess,
              error: null,
            ),
          );
        },
      );
    } catch (e) {
      SimpleLogger.logError('VERIFY_CODE', 'Exception occurred', e.toString());
      emit(
        state.copyWith(
          status: AuthStatus.codeVerificationError,
          error: e.toString(),
        ),
      );
    }
  }

  // Login method
  Future<void> login({required String password}) async {
    final email = state.email;
    final phoneNumber = state.phoneNumber;

    if (email == null || phoneNumber == null) {
      SimpleLogger.logError(
        'LOGIN',
        'Missing user data',
        'Email or phone number is null',
      );
      emit(
        state.copyWith(
          status: AuthStatus.loginError,
          error: 'User data not found. Please try signing up again.',
        ),
      );
      return;
    }

    SimpleLogger.logInfo('Attempting login', tag: 'LOGIN');

    emit(state.copyWith(status: AuthStatus.loginLoading, error: null));

    try {
      final result = await _authRepository.login(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      result.match(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.loginError,
              error: failure.message,
            ),
          );
        },
        (loginResponse) {
          SimpleLogger.logSuccess('Login successful', tag: 'LOGIN');
          emit(
            state.copyWith(
              status: AuthStatus.loginSuccess,
              loginResponse: loginResponse,
              error: null,
            ),
          );
        },
      );
    } catch (e) {
      SimpleLogger.logError('LOGIN', 'Exception occurred', e.toString());
      emit(state.copyWith(status: AuthStatus.loginError, error: e.toString()));
    }
  }

  // Login with credentials method
  Future<void> loginWithCredentials({
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    SimpleLogger.logInfo('Attempting login with credentials', tag: 'LOGIN');

    emit(state.copyWith(status: AuthStatus.loginLoading, error: null));

    try {
      final result = await _authRepository.login(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      result.match(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.loginError,
              error: failure.message,
            ),
          );
        },
        (loginResponse) {
          SimpleLogger.logSuccess('Login successful', tag: 'LOGIN');
          emit(
            state.copyWith(
              status: AuthStatus.loginSuccess,
              loginResponse: loginResponse,
              error: null,
            ),
          );
        },
      );
    } catch (e) {
      SimpleLogger.logError('LOGIN', 'Exception occurred', e.toString());
      emit(state.copyWith(status: AuthStatus.loginError, error: e.toString()));
    }
  }

  // Send forgot code method
  Future<void> sendForgotCode({
    required String email,
    required String phoneNumber,
  }) async {
    SimpleLogger.logInfo('Sending forgot code', tag: 'FORGOT_CODE');

    emit(state.copyWith(status: AuthStatus.forgotCodeLoading, error: null));

    try {
      final result = await _authRepository.sendForgotCode(
        email: email,
        phoneNumber: phoneNumber,
      );
      result.match(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.forgotCodeError,
              error: failure.message,
            ),
          );
        },
        (_) {
          SimpleLogger.logSuccess(
            'Forgot code sent successfully',
            tag: 'FORGOT_CODE',
          );
          emit(
            state.copyWith(status: AuthStatus.forgotCodeSuccess, error: null),
          );
        },
      );
    } catch (e) {
      SimpleLogger.logError('FORGOT_CODE', 'Exception occurred', e.toString());
      emit(
        state.copyWith(status: AuthStatus.forgotCodeError, error: e.toString()),
      );
    }
  }

  // Reset password method
  Future<void> resetPassword({
    required String email,
    required String phoneNumber,
    required String code,
    required String newPassword,
  }) async {
    print('🔍 DEBUG: AuthCubit resetPassword called');
    print('🔍 DEBUG: Email: $email');
    print('🔍 DEBUG: PhoneNumber: $phoneNumber');
    print('🔍 DEBUG: Code: $code');
    print('🔍 DEBUG: NewPassword: $newPassword');

    SimpleLogger.logInfo('Resetting password', tag: 'RESET_PASSWORD');

    emit(state.copyWith(status: AuthStatus.resetPasswordLoading, error: null));

    try {
      final result = await _authRepository.resetPassword(
        email: email,
        phoneNumber: phoneNumber,
        code: code,
        newPassword: newPassword,
      );
      result.match(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.resetPasswordError,
              error: failure.message,
            ),
          );
        },
        (_) {
          SimpleLogger.logSuccess(
            'Password reset successfully',
            tag: 'RESET_PASSWORD',
          );
          emit(
            state.copyWith(
              status: AuthStatus.resetPasswordSuccess,
              error: null,
            ),
          );
        },
      );
    } catch (e) {
      SimpleLogger.logError(
        'RESET_PASSWORD',
        'Exception occurred',
        e.toString(),
      );
      emit(
        state.copyWith(
          status: AuthStatus.resetPasswordError,
          error: e.toString(),
        ),
      );
    }
  }
}
