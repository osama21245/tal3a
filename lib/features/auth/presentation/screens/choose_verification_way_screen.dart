import 'package:flutter/material.dart';
import 'package:tal3a/core/widgets/auth_screen_header_widget.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';

import '../widgets/choose_verification_screen/choose_verification_form_widget.dart';

class ChooseVerificationWayScreen extends StatelessWidget {
  final bool isFromForgotPassword;
  final String? userEmail;
  final String? userPhone;

  const ChooseVerificationWayScreen({
    super.key,
    required this.isFromForgotPassword,
    this.userEmail,
    this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ScreenHeaderWidget(title: 'Choose Verification Way', activeSteps: 2),
          // Form component as separate overlay
          ScreenContentWidget(
            screenHeight: screenHeight,
            child: ChooseVerificationFormWidget(
              isFromForgotPassword: isFromForgotPassword,
              userEmail: userEmail,
              userPhone: userPhone,
            ),
          ),
        ],
      ),
    );
  }
}
