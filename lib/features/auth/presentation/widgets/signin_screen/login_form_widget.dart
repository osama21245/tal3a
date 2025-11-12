import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import 'package:tal3a/features/auth/presentation/screens/forgot_password_input_screen.dart';
import 'package:tal3a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tal3a/core/routing/routes.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/dimentions.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/utils/animation_helper.dart';
import '../../../../../core/widgets/widgets.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.please_fill_all_fields'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if input is email or phone
    final bool isEmail = _emailController.text.contains('@');

    // Call login with appropriate parameters
    context.read<AuthCubit>().loginWithCredentials(
      email: isEmail ? _emailController.text : '',
      phoneNumber: isEmail ? '' : _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isLoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('auth.login_successful'.tr()),
              backgroundColor: Colors.green,
            ),
          );

          // Handle navigation based on profile completion
          if (state.loginResponse != null) {
            final user = state.loginResponse!.data;

            // Check if profile setup is completed
            if (user.profileCompletion) {
              context.read<UserController>().completeProfileSetup();
              // User is logged in and profile is complete - go to home
              Navigator.of(context).pushReplacementNamed(Routes.homeScreen);
            } else {
              // User is logged in but profile is not complete - go to interests
              Navigator.of(
                context,
              ).pushReplacementNamed(Routes.selectIntentsScreen);
            }
          }
        } else if (state.isLoginError && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          AnimationHelper.fadeIn(
            child: Text(
              'auth.login_title'.tr(),
              style: AppTextStyles.signinSubtitleStyle,
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),

          // Form Fields
          AnimationHelper.fadeIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email/Phone Field
                CustomTextFieldWidget(
                  controller: _emailController,
                  hintText: 'auth.email_or_phone'.tr(),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Password Field
                CustomTextFieldWidget(
                  controller: _passwordController,
                  hintText: 'auth.enter_password'.tr(),
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorPalette.textPlaceholder,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: SecondaryButtonWidget(
                    text: 'auth.forgot_password'.tr(),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => const ForgotPasswordInputScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Login Button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.isLoginLoading;
                    return PrimaryButtonWidget(
                      text:
                          isLoading
                              ? 'auth.logging_in'.tr()
                              : 'auth.login'.tr(),
                      onPressed: isLoading ? null : _handleLogin,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
