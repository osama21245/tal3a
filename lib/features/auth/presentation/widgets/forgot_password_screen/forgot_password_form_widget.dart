import 'package:flutter/material.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/dimentions.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/utils/animation_helper.dart';
import '../../../../../features/auth/presentation/screens/otp_verification_screen.dart';

class ForgotPasswordFormWidget extends StatefulWidget {
  const ForgotPasswordFormWidget({super.key});

  @override
  State<ForgotPasswordFormWidget> createState() =>
      _ForgotPasswordFormWidgetState();
}

class _ForgotPasswordFormWidgetState extends State<ForgotPasswordFormWidget> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Description Text
        AnimationHelper.titleAnimation(
          child: Text(
            'Please enter your email and we will send an OTP code in the next step to reset your password.',
            style: AppTextStyles.formDescriptionStyle,
          ),
        ),

        const SizedBox(height: 20),

        // Email Field
        AnimationHelper.cardAnimation(
          index: 0,
          child: Container(
            height: 57,
            decoration: BoxDecoration(
              color: ColorPalette.cardGrey,
              borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
            ),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              style: AppTextStyles.formInputTextStyle,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: AppTextStyles.formHintTextStyle,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  left: Dimensions.paddingLarge,
                  right: Dimensions.paddingLarge,
                  top: 30,
                  bottom: 13,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Continue Button
        AnimationHelper.slideUp(
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_emailController.text.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => OtpVerificationScreen(
                            email: _emailController.text,
                            isFromForgotPassword: true,
                          ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                ),
                elevation: 0,
              ),
              child: Text('Continue', style: AppTextStyles.tabButtonStyle),
            ),
          ),
        ),
      ],
    );
  }
}
