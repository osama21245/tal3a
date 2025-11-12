import 'package:flutter/material.dart';
import 'package:tal3a/core/widgets/auth_screen_header_widget.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import '../widgets/otp_verification_screen/otp_form_widget.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final bool isFromForgotPassword;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.isFromForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Full background with exact Figma color
          ScreenHeaderWidget(title: 'OTP Verification', activeSteps: 3),

          ScreenContentWidget(
            screenHeight: screenHeight,
            child: OtpFormWidget(
              email: email,
              isFromForgotPassword: isFromForgotPassword,
            ),
          ),
        ],
      ),
    );
  }
}
