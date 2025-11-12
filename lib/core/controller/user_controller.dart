import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tal3a/core/routing/routes.dart';
import 'package:tal3a/core/services/auth_service.dart';
import 'package:tal3a/features/auth/data/models/user_model.dart';

// App State Enum
enum AppState { onboarding, unauthenticated, authenticated, profileSetup }

// User Controller Status
enum UserControllerStatus { initial, loading, success, error }

// User Controller State
class UserControllerState {
  final UserControllerStatus status;
  final AppState appState;
  final String? nextRoute;
  final String? error;
  final UserModel? user;

  UserControllerState({
    this.status = UserControllerStatus.initial,
    this.appState = AppState.onboarding,
    this.nextRoute,
    this.error,
    this.user,
  });

  UserControllerState copyWith({
    UserControllerStatus? status,
    AppState? appState,
    String? nextRoute,
    String? error,
    UserModel? user,
  }) {
    return UserControllerState(
      status: status ?? this.status,
      appState: appState ?? this.appState,
      nextRoute: nextRoute ?? this.nextRoute,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

// Extension for easy state checking
extension UserControllerStateExtension on UserControllerState {
  bool get isInitial => status == UserControllerStatus.initial;
  bool get isLoading => status == UserControllerStatus.loading;
  bool get isSuccess => status == UserControllerStatus.success;
  bool get isError => status == UserControllerStatus.error;
}

// User Controller
class UserController extends Cubit<UserControllerState> {
  static const String _onboardingKey = 'onboarding_completed';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  UserController() : super(UserControllerState());

  // Check app state on startup
  Future<void> checkAppState() async {
    emit(state.copyWith(status: UserControllerStatus.loading));

    try {
      // Check if onboarding is completed
      final onboardingCompleted = await _storage.read(key: _onboardingKey);

      if (onboardingCompleted == null || onboardingCompleted != 'true') {
        // User hasn't completed onboarding
        emit(
          state.copyWith(
            status: UserControllerStatus.success,
            appState: AppState.onboarding,
            nextRoute: Routes.onboardingScreen,
          ),
        );
        return;
      }

      // Check if user is logged in
      final isLoggedIn = await _authService.isLoggedIn();
      if (!isLoggedIn) {
        // User not logged in, navigate to sign in
        emit(
          state.copyWith(
            status: UserControllerStatus.success,
            appState: AppState.unauthenticated,
            nextRoute: Routes.signInScreen,
          ),
        );
        return;
      }

      // User is logged in, check if we have valid cached data
      UserModel? user = await _authService.getCachedUserData();

      if (user == null) {
        // No cached data or expired, try to get fresh data
        try {
          user = await _authService.getUserInfo();
        } catch (e) {
          // Failed to get user info, logout and go to sign in
          await _authService.logout();
          emit(
            state.copyWith(
              status: UserControllerStatus.success,
              appState: AppState.unauthenticated,
              nextRoute: Routes.signInScreen,
            ),
          );
          return;
        }
      }

      // Check if profile setup is completed
      // First check the user's profileCompletion field from server data
      if (!user.profileCompletion) {
        // Profile setup not completed, navigate to interests screen
        emit(
          state.copyWith(
            status: UserControllerStatus.success,
            appState: AppState.profileSetup,
            nextRoute: Routes.selectIntentsScreen,
            user: user,
          ),
        );
        return;
      }

      // Also check local storage as backup
      final isProfileSetupCompleted =
          await _authService.isProfileSetupCompleted();
      if (!isProfileSetupCompleted) {
        // Profile setup not completed, navigate to interests screen
        emit(
          state.copyWith(
            status: UserControllerStatus.success,
            appState: AppState.profileSetup,
            nextRoute: Routes.selectIntentsScreen,
            user: user,
          ),
        );
        return;
      }

      // User is fully authenticated and setup, navigate to home
      emit(
        state.copyWith(
          status: UserControllerStatus.success,
          appState: AppState.authenticated,
          nextRoute: Routes.homeScreen,
          user: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserControllerStatus.error,
          error: 'Failed to check app state: $e',
        ),
      );
    }
  }

  // Complete onboarding
  Future<void> completeOnboarding() async {
    try {
      await _storage.write(key: _onboardingKey, value: 'true');

      emit(
        state.copyWith(
          status: UserControllerStatus.success,
          appState: AppState.unauthenticated,
          nextRoute: Routes.signInScreen,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserControllerStatus.error,
          error: 'Failed to complete onboarding: $e',
        ),
      );
    }
  }

  // Reset app state (for testing or complete reset)
  Future<void> resetAppState() async {
    try {
      await _storage.deleteAll();

      emit(
        state.copyWith(
          status: UserControllerStatus.success,
          appState: AppState.onboarding,
          nextRoute: Routes.onboardingScreen,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserControllerStatus.error,
          error: 'Failed to reset app state: $e',
        ),
      );
    }
  }

  // Handle successful login
  Future<void> handleLogin(UserModel user) async {
    try {
      // Cache user data
      await _authService.cacheUserData(user);

      // Check if profile setup is completed
      // First check the user's profileCompletion field from server data
      if (!user.profileCompletion) {
        // Navigate to interests screen
        emit(
          state.copyWith(
            status: UserControllerStatus.success,
            appState: AppState.profileSetup,
            nextRoute: Routes.selectIntentsScreen,
            user: user,
          ),
        );
        return;
      }

      // Also check local storage as backup
      final isProfileSetupCompleted =
          await _authService.isProfileSetupCompleted();

      if (!isProfileSetupCompleted) {
        // Navigate to interests screen
        emit(
          state.copyWith(
            status: UserControllerStatus.success,
            appState: AppState.profileSetup,
            nextRoute: Routes.selectIntentsScreen,
            user: user,
          ),
        );
      } else {
        // Navigate to home
        emit(
          state.copyWith(
            status: UserControllerStatus.success,
            appState: AppState.authenticated,
            nextRoute: Routes.homeScreen,
            user: user,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: UserControllerStatus.error,
          error: 'Failed to handle login: $e',
        ),
      );
    }
  }

  // Complete profile setup
  Future<void> completeProfileSetup() async {
    try {
      await _authService.markProfileSetupCompleted();

      emit(
        state.copyWith(
          status: UserControllerStatus.success,
          appState: AppState.authenticated,
          nextRoute: Routes.homeScreen,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserControllerStatus.error,
          error: 'Failed to complete profile setup: $e',
        ),
      );
    }
  }

  // Handle token refresh
  Future<bool> refreshToken() async {
    try {
      print('🔍 UserController: Attempting to refresh token');
      final newToken = await _authService.refreshAccessToken();

      if (newToken != null) {
        print('🔍 UserController: Token refreshed successfully');
        return true;
      } else {
        print('🔍 UserController: Token refresh failed');
        return false;
      }
    } catch (e) {
      print('🔍 UserController: Error refreshing token: $e');
      return false;
    }
  }

  // Handle authentication error (logout user)
  Future<void> handleAuthenticationError() async {
    try {
      print('🔍 UserController: Handling authentication error - logging out');
      await _authService.logout();

      emit(
        state.copyWith(
          status: UserControllerStatus.success,
          appState: AppState.unauthenticated,
          nextRoute: Routes.signInScreen,
          user: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserControllerStatus.error,
          error: 'Failed to handle authentication error: $e',
        ),
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authService.logout();

      emit(
        state.copyWith(
          status: UserControllerStatus.success,
          appState: AppState.unauthenticated,
          nextRoute: Routes.signInScreen,
          user: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserControllerStatus.error,
          error: 'Failed to logout: $e',
        ),
      );
    }
  }

  // Helper methods for easy access
  Future<bool> isOnboardingCompleted() async {
    final completed = await _storage.read(key: _onboardingKey);
    return completed == 'true';
  }

  // Read user
  Future<void> readUser() async {
    final user = await _authService.getUserInfo();
    if (user != null) {
      emit(state.copyWith(user: user));
    } else {
      emit(state.copyWith(user: null));
    }
  }
}
