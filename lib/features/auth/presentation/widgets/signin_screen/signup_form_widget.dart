import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/dimentions.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/utils/animation_helper.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/simple_logger.dart';

class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({super.key});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    // Log form submission attempt
    SimpleLogger.logInfo('Signup form submission attempt', tag: 'FORM');

    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      SimpleLogger.logWarning(
        'Form validation failed: Missing required fields',
        tag: 'FORM',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.please_fill_all_fields'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      SimpleLogger.logWarning(
        'Form validation failed: Passwords do not match',
        tag: 'FORM',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.passwords_dont_match'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SimpleLogger.logInfo('Form validation passed, calling signup', tag: 'FORM');

    context.read<AuthCubit>().signup(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isSignupSuccess && state.signupResponse != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.signupResponse!.message),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to the next screen after successful signup
          Navigator.of(context).pushNamed(Routes.chooseVerificationWayScreen);
        } else if (state.isSignupError && state.error != null) {
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
              'auth.signup_title'.tr(),
              style: AppTextStyles.signinSubtitleStyle,
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),

          // Form Fields
          AnimationHelper.fadeIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full Name Field
                CustomTextFieldWidget(
                  controller: _fullNameController,
                  hintText: 'auth.full_name'.tr(),
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Email Field
                CustomTextFieldWidget(
                  controller: _emailController,
                  hintText: 'auth.email'.tr(),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Phone Number Field
                CustomTextFieldWidget(
                  controller: _phoneController,
                  hintText: 'auth.phone_number'.tr(),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Password Field
                CustomTextFieldWidget(
                  controller: _passwordController,
                  hintText: 'auth.password'.tr(),
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

                // Confirm Password Field
                CustomTextFieldWidget(
                  controller: _confirmPasswordController,
                  hintText: 'auth.confirm_password'.tr(),
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorPalette.textPlaceholder,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Signup Button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.isSignupLoading;
                    return PrimaryButtonWidget(
                      text:
                          isLoading
                              ? 'auth.signing_up'.tr()
                              : 'auth.signup'.tr(),
                      onPressed: isLoading ? null : _handleSignup,
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
