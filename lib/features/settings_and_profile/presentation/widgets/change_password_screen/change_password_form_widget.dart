import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/utils/animation_helper.dart';
import '../../controllers/change_password_cubit.dart';

class ChangePasswordFormWidget extends StatefulWidget {
  const ChangePasswordFormWidget({super.key});

  @override
  State<ChangePasswordFormWidget> createState() =>
      _ChangePasswordFormWidgetState();
}

class _ChangePasswordFormWidgetState extends State<ChangePasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Add listener to make requirements interactive
    _newPasswordController.addListener(() {
      setState(() {}); // Rebuild when text changes
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.successMessage ?? 'Password changed successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Failed to change password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  child: Text(
                    'The New Password Must Be Different From The Current Password',
                    style: AppTextStyles.settingsProfileEmailStyle.copyWith(
                      color: ColorPalette.textDark,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                // Old Password Field
                _buildPasswordField(
                  controller: _oldPasswordController,
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  isVisible: _isOldPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // New Password Field
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'New password',
                  hint: 'Enter your new password',
                  isVisible: _isNewPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Password Requirements
                _buildPasswordRequirements(),
                SizedBox(height: 16.h),

                // Confirm Password Field
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm password',
                  hint: 'Confirm your new password',
                  isVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),

                // Submit Button
                AnimationHelper.fadeIn(
                  duration: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: AppTextStyles.settingsMenuItemStyle.copyWith(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 57.h,
          decoration: BoxDecoration(
            color: ColorPalette.cardGrey, // Use cardGrey (#FAFAFA) from Figma
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            validator: validator,
            style: AppTextStyles.settingsMenuItemStyle.copyWith(
              color: ColorPalette.textDark, // Dark text for input
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: AppTextStyles.settingsProfileEmailStyle.copyWith(
                color:
                    ColorPalette
                        .textPlaceholder, // Use placeholder color (#72848D)
                fontSize: 16.sp,
              ),
              hintText: hint,
              hintStyle: AppTextStyles.settingsProfileEmailStyle.copyWith(
                color:
                    ColorPalette
                        .textPlaceholder, // Use placeholder color (#72848D)
                fontSize: 16.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 19.w,
                vertical: 19.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: Column(
        children: [
          _buildRequirementItem(
            text: 'There must be at least 8 characters',
            isValid: _newPasswordController.text.length >= 8,
          ),
          SizedBox(height: 8.h),
          _buildRequirementItem(
            text: 'There must be a unique code like @!#',
            isValid: _newPasswordController.text.contains(
              RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem({required String text, required bool isValid}) {
    return Row(
      children: [
        // Use the exact checkmark SVG - grey when unchecked, green when checked
        SvgPicture.asset(
          'assets/icons/changepassword_check.svg',
          width: 20.w,
          height: 20.h,
          color:
              isValid
                  ? ColorPalette.successGreen
                  : ColorPalette.textPlaceholder,
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.settingsProfileEmailStyle.copyWith(
              color:
                  isValid
                      ? ColorPalette.successGreen
                      : ColorPalette.textPlaceholder,
              fontSize: 14.sp,
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
