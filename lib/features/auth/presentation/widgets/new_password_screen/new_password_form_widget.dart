import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/dimentions.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/utils/animation_helper.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/routing/routes.dart';

class NewPasswordFormWidget extends StatefulWidget {
  final String email;
  final String code;

  const NewPasswordFormWidget({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<NewPasswordFormWidget> createState() => _NewPasswordFormWidgetState();
}

class _NewPasswordFormWidgetState extends State<NewPasswordFormWidget> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Determine if email or phone based on email format
    final bool isEmail = widget.email.contains('@');

    print('🔍 DEBUG: New Password Form - Email/Phone: ${widget.email}');
    print('🔍 DEBUG: New Password Form - Code: ${widget.code}');
    print('🔍 DEBUG: New Password Form - Is Email: $isEmail');

    context.read<AuthCubit>().resetPassword(
      email: isEmail ? widget.email : '',
      phoneNumber: isEmail ? '' : widget.email,
      code: widget.code,
      newPassword: _newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back to login screen
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(Routes.signInScreen, (route) => false);
        } else if (state.isResetPasswordError && state.error != null) {
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
              'Create New Password',
              style: AppTextStyles.signinSubtitleStyle,
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),

          // Description
          AnimationHelper.fadeIn(
            child: Text(
              'Your new password must be different from previously used passwords.',
              style: AppTextStyles.formDescriptionStyle,
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),

          // Form Fields
          AnimationHelper.fadeIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // New Password Field
                CustomTextFieldWidget(
                  controller: _newPasswordController,
                  hintText: 'New Password',
                  obscureText: !_isNewPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorPalette.textPlaceholder,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Confirm Password Field
                CustomTextFieldWidget(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm New Password',
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

                // Reset Password Button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.isResetPasswordLoading;
                    return PrimaryButtonWidget(
                      text:
                          isLoading
                              ? 'Resetting Password...'
                              : 'Reset Password',
                      onPressed: isLoading ? null : _handleResetPassword,
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
