import 'package:flutter/material.dart';
import 'package:tal3a/core/widgets/auth_screen_header_widget.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import '../widgets/new_password_screen/new_password_form_widget.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = arguments?['email'] ?? '';
    final code = arguments?['code'] ?? '';

    print('🔍 DEBUG: New Password Screen - Arguments: $arguments');
    print('🔍 DEBUG: New Password Screen - Email: $email');
    print('🔍 DEBUG: New Password Screen - Code: $code');

    return Scaffold(
      body: Stack(
        children: [
          // Full background with exact Figma color
          ScreenHeaderWidget(title: 'New Password', activeSteps: 4),

          ScreenContentWidget(
            screenHeight: screenHeight,
            child: NewPasswordFormWidget(email: email, code: code),
          ),
        ],
      ),
    );
  }
}
