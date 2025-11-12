import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/dimentions.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

import '../../screens/otp_verification_screen.dart';

class ChooseVerificationFormWidget extends StatelessWidget {
  final bool isFromForgotPassword;
  final String? userEmail;
  final String? userPhone;

  const ChooseVerificationFormWidget({
    super.key,
    required this.isFromForgotPassword,
    this.userEmail,
    this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isVerificationSuccess || state.isForgotCodeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification code sent successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to OTP verification screen
          final emailToPass =
              isFromForgotPassword
                  ? (userEmail ?? userPhone ?? '')
                  : (state.email ?? '');

          print('🔍 DEBUG: Navigating to OTP with email: $emailToPass');
          print('🔍 DEBUG: isFromForgotPassword: $isFromForgotPassword');
          print('🔍 DEBUG: userEmail: $userEmail');
          print('🔍 DEBUG: userPhone: $userPhone');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => OtpVerificationScreen(
                    email: emailToPass,
                    isFromForgotPassword: isFromForgotPassword,
                  ),
            ),
          );
        } else if ((state.isVerificationError || state.isForgotCodeError) &&
            state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return _VerificationFormContent(
          isFromForgotPassword: isFromForgotPassword,
          email: isFromForgotPassword ? userEmail : state.email,
          phoneNumber: isFromForgotPassword ? userPhone : state.phoneNumber,
          isLoading: state.isVerificationLoading || state.isForgotCodeLoading,
        );
      },
    );
  }
}

class _VerificationFormContent extends StatefulWidget {
  final bool isFromForgotPassword;
  final String? email;
  final String? phoneNumber;
  final bool isLoading;

  const _VerificationFormContent({
    required this.isFromForgotPassword,
    required this.email,
    required this.phoneNumber,
    required this.isLoading,
  });

  @override
  State<_VerificationFormContent> createState() =>
      _VerificationFormContentState();
}

class _VerificationFormContentState extends State<_VerificationFormContent> {
  String? selectedVerificationMethod;

  void _handleVerificationMethodSelection(String method) {
    setState(() {
      selectedVerificationMethod =
          selectedVerificationMethod == method ? null : method;
    });
  }

  void _sendVerificationCode() {
    if (selectedVerificationMethod == null) return;

    if (widget.isFromForgotPassword) {
      // For forgot password flow, use sendForgotCode
      final email = widget.email ?? '';
      final phoneNumber = widget.phoneNumber ?? '';

      print('🔍 DEBUG: Forgot password - Email: $email, Phone: $phoneNumber');

      context.read<AuthCubit>().sendForgotCode(
        email: email,
        phoneNumber: phoneNumber,
      );
    } else {
      // For signup flow, use sendVerificationCode
      context.read<AuthCubit>().sendVerificationCode(
        type: selectedVerificationMethod!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Description Text
        AnimationHelper.fadeIn(
          child: Text(
            'auth.choose_verification_method'.tr(),
            style: AppTextStyles.formDescriptionStyle,
          ),
        ),

        const SizedBox(height: Dimensions.spacingMedium),

        // Forms Container
        Column(
          children: [
            // Phone Number Option
            AnimationHelper.cardAnimation(
              index: 0,
              child: AnimatedScale(
                scale: selectedVerificationMethod == 'sms' ? 1.02 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: () => _handleVerificationMethodSelection('sms'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusMedium,
                      ),
                      border: Border.all(
                        color:
                            selectedVerificationMethod == 'sms'
                                ? ColorPalette.primaryBlue.withOpacity(0.3)
                                : const Color(0xFFE3E7EC).withOpacity(0.7),
                        width: selectedVerificationMethod == 'sms' ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(2, 6),
                          blurRadius: 25,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Checkbox
                        Positioned(
                          left: 19.5,
                          top: 14,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color:
                                  selectedVerificationMethod == 'sms'
                                      ? ColorPalette.primaryBlue
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusMedium,
                              ),
                              border: Border.all(
                                color:
                                    selectedVerificationMethod == 'sms'
                                        ? ColorPalette.primaryBlue
                                        : const Color(0xFFE3E7EC),
                                width: 1,
                              ),
                            ),
                            child:
                                selectedVerificationMethod == 'sms'
                                    ? AnimatedScale(
                                      scale: 1.0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                    : null,
                          ),
                        ),

                        // Phone Number Text
                        Positioned(
                          left: 73,
                          top: 14,
                          child: Text(
                            'auth.phone_number'.tr(),
                            style: AppTextStyles.verificationOptionTitleStyle,
                          ),
                        ),

                        // Masked Phone Number
                        Positioned(
                          left: 73,
                          top: 40,
                          child: Text(
                            widget.phoneNumber != null
                                ? '•••• •••• •••• ${widget.phoneNumber!.substring(widget.phoneNumber!.length - 4)}'
                                : '•••• •••• •••• 87652',
                            style:
                                AppTextStyles.verificationOptionSubtitleStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: Dimensions.spacingMedium),

            // Email Option
            AnimationHelper.cardAnimation(
              index: 1,
              child: AnimatedScale(
                scale: selectedVerificationMethod == 'email' ? 1.02 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: () => _handleVerificationMethodSelection('email'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusMedium,
                      ),
                      border: Border.all(
                        color:
                            selectedVerificationMethod == 'email'
                                ? ColorPalette.primaryBlue.withOpacity(0.3)
                                : const Color(0xFFE3E7EC).withOpacity(0.7),
                        width: selectedVerificationMethod == 'email' ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(2, 6),
                          blurRadius: 25,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Checkbox
                        Positioned(
                          left: 19.5,
                          top: 14,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color:
                                  selectedVerificationMethod == 'email'
                                      ? ColorPalette.primaryBlue
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusMedium,
                              ),
                              border: Border.all(
                                color:
                                    selectedVerificationMethod == 'email'
                                        ? ColorPalette.primaryBlue
                                        : const Color(0xFFE3E7EC),
                                width: 1,
                              ),
                            ),
                            child:
                                selectedVerificationMethod == 'email'
                                    ? AnimatedScale(
                                      scale: 1.0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                    : null,
                          ),
                        ),

                        // Email Text
                        Positioned(
                          left: 73,
                          top: 14,
                          child: Text(
                            'auth.email'.tr(),
                            style: AppTextStyles.verificationOptionTitleStyle,
                          ),
                        ),

                        // Masked Email
                        Positioned(
                          left: 73,
                          top: 40,
                          child: Text(
                            widget.email != null
                                ? '•••• •••• •••• ${widget.email!.split('@')[0].substring(0, 2)}***@${widget.email!.split('@')[1]}'
                                : '•••• •••• •••• aea@gmail.com',
                            style:
                                AppTextStyles.verificationOptionSubtitleStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: Dimensions.spacingMedium),

        // Continue Button
        AnimationHelper.slideUp(
          child: AnimatedOpacity(
            opacity: selectedVerificationMethod != null ? 1.0 : 0.6,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              height: Dimensions.buttonHeight,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    selectedVerificationMethod != null && !widget.isLoading
                        ? _sendVerificationCode
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedVerificationMethod != null
                          ? ColorPalette.primaryBlue
                          : ColorPalette.textPlaceholder,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radiusMedium,
                    ),
                  ),
                  elevation: 0,
                ),
                child:
                    widget.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text('auth.continue'.tr(), style: AppTextStyles.tabButtonStyle),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
