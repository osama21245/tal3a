import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/widgets/auth_screen_header_widget.dart';
import '../widgets/forgot_password_screen/forgot_password_form_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ScreenHeaderWidget(title: 'Forgot Password', activeSteps: 1),

          // Form component as separate overlay
          ScreenContentWidget(
            screenHeight: screenHeight,
            child: const ForgotPasswordFormWidget(),
          ),
        ],
      ),
    );
  }
}
