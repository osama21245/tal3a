import 'package:flutter/material.dart';
import 'package:tal3a/core/widgets/auth_screen_header_widget.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import '../widgets/forgot_password_input_screen/forgot_password_input_form_widget.dart';

class ForgotPasswordInputScreen extends StatelessWidget {
  const ForgotPasswordInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Full background with exact Figma color
          ScreenHeaderWidget(title: 'Forgot Password', activeSteps: 1),

          ScreenContentWidget(
            screenHeight: screenHeight,
            child: const ForgotPasswordInputFormWidget(),
          ),
        ],
      ),
    );
  }
}
