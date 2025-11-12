import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/utils/animation_helper.dart';
import '../../../../core/controller/user_controller.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/signin_screen/auth_toggle_widget.dart';
import '../widgets/signin_screen/login_form_widget.dart';
import '../widgets/signin_screen/signup_form_widget.dart';
import '../widgets/signin_screen/social_login_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isLoginSuccess && state.loginResponse != null) {
          // Handle successful login
          context.read<UserController>().handleLogin(state.loginResponse!.data);
        } else if (state.isLoginError) {
          // Handle login error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final authCubit = context.read<AuthCubit>();

          return Scaffold(
            body: Stack(
              children: [
                // Full background image
                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(authCubit.currentBackgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        child: Stack(
                          children: [
                            // Tal3a Logo positioned in background
                            Positioned(
                              bottom: 30.h,
                              right: 20,
                              child: Image.asset(
                                'assets/images/tal3a_logo.png',
                                width: 67,
                                height: 43,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),

                // Form component as separate overlay with entrance animation
                Positioned(
                  top: screenHeight * 0.37 - 24, // Overlap by 24px
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimationHelper.slideUp(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorPalette.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(Dimensions.paddingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthToggleWidget(
                              isLoginSelected: authCubit.isLoginSelected,
                              onToggle: (isLogin) {
                                if (isLogin) {
                                  authCubit.switchToLogin();
                                } else {
                                  authCubit.switchToSignup();
                                }
                              },
                            ),

                            const SizedBox(height: Dimensions.spacingMedium),

                            // Form switching with animation
                            if (authCubit.isLoginSelected)
                              AnimationHelper.fadeIn(
                                child: const LoginFormWidget(
                                  key: ValueKey('login_form'),
                                ),
                              )
                            else
                              AnimationHelper.fadeIn(
                                child: const SignupFormWidget(
                                  key: ValueKey('signup_form'),
                                ),
                              ),

                            const SizedBox(height: Dimensions.spacingMedium),

                            const SocialLoginWidget(),

                            const SizedBox(height: Dimensions.spacingMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
