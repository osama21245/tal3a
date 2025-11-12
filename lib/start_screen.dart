import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import 'package:tal3a/core/routing/routes.dart';
import 'package:tal3a/core/services/auth_service.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _hasNavigated = false;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
    // Check app state when the start screen loads
    //check if the user is logged in
    //_authService.clearUserData();
    //_authService.clearAccessToken();
    context.read<UserController>().checkAppState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UserController, UserControllerState>(
        listener: (context, state) {
          if (state.isSuccess && state.nextRoute != null && !_hasNavigated) {
            _hasNavigated = true;

            // Simple navigation based on app state
            if (state.appState == AppState.authenticated) {
              // User is logged in and profile is complete - go to home
              Navigator.of(context).pushReplacementNamed(Routes.homeScreen);
            } else if (state.appState == AppState.profileSetup) {
              // User is logged in but profile is not complete - go to interests
              Navigator.of(
                context,
              ).pushReplacementNamed(Routes.selectIntentsScreen);
            } else if (state.appState == AppState.onboarding) {
              // User needs onboarding
              Navigator.of(
                context,
              ).pushReplacementNamed(Routes.onboardingScreen);
            } else {
              // Default fallback
              Navigator.of(
                context,
              ).pushReplacementNamed(Routes.onboardingScreen);
            }
          } else if (state.isError) {
            // Handle error state
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? 'Something went wrong'),
                  backgroundColor: Colors.red,
                ),
              );
              // Navigate to onboarding as fallback
              Navigator.of(
                context,
              ).pushReplacementNamed(Routes.onboardingScreen);
            });
          }
        },
        child: BlocBuilder<UserController, UserControllerState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.isError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error ?? 'Unknown error',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserController>().checkAppState();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Default loading state
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
