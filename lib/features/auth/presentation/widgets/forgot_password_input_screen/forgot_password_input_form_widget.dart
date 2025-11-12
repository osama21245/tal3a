import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/const/dimentions.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import 'package:tal3a/core/widgets/widgets.dart';
import '../../screens/choose_verification_way_screen.dart';

class ForgotPasswordInputFormWidget extends StatefulWidget {
  const ForgotPasswordInputFormWidget({super.key});

  @override
  State<ForgotPasswordInputFormWidget> createState() =>
      _ForgotPasswordInputFormWidgetState();
}

class _ForgotPasswordInputFormWidgetState
    extends State<ForgotPasswordInputFormWidget> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final emailOrPhone = _emailOrPhoneController.text.trim();

    // Navigate to choose verification way screen with the email/phone data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ChooseVerificationWayScreen(
              isFromForgotPassword: true,
              userEmail: emailOrPhone,
              userPhone: emailOrPhone,
            ),
      ),
    );
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.please_fill_all_fields'.tr();
    }

    final trimmedValue = value.trim();

    // Check if it's an email
    if (trimmedValue.contains('@')) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmedValue)) {
        return 'Please enter a valid email address';
      }
    } else {
      // Check if it's a phone number (basic validation)
      if (trimmedValue.length < 10) {
        return 'Please enter a valid phone number';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          AnimationHelper.fadeIn(
            child: Text(
              'auth.enter_email_or_phone'.tr(),
              style: AppTextStyles.signinSubtitleStyle,
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),

          // Description
          AnimationHelper.fadeIn(
            child: Text(
              'auth.forgot_password_subtitle'.tr(),
              style: AppTextStyles.formDescriptionStyle,
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),

          // Form Fields
          AnimationHelper.fadeIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email/Phone Field
                CustomTextFieldWidget(
                  controller: _emailOrPhoneController,
                  hintText: 'auth.email_or_phone'.tr(),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmailOrPhone,
                ),

                const SizedBox(height: Dimensions.spacingMedium),

                // Continue Button
                PrimaryButtonWidget(
                  text: 'auth.continue'.tr(),
                  onPressed: _handleContinue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
