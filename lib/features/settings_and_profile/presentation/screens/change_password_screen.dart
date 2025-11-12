import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/utils/animation_helper.dart';
import '../widgets/change_password_screen/change_password_form_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.settingsMainBg,
      body: Column(
        children: [
          // Header with Training App Bar
          CustomAppBar(
            title: 'Change Password',
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          SizedBox(height: 10.h),

          // Main Content
          Expanded(
            child: Container(
              color: ColorPalette.settingsMainBg,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Change Password Form with animation
                    AnimationHelper.fadeIn(
                      duration: const Duration(milliseconds: 400),
                      child: ChangePasswordFormWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
