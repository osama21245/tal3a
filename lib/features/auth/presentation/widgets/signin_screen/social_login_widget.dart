import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "or" text
        Row(
          children: [
            Expanded(
              child: Container(height: 1, color: ColorPalette.dividerColor),
            ),
            const SizedBox(width: 10),
            Text('auth.or_continue_with'.tr(), style: AppTextStyles.orTextStyle),
            const SizedBox(width: 10),
            Expanded(
              child: Container(height: 1, color: ColorPalette.dividerColor),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Social Login Buttons
        Row(
          children: [
            // Google Button
            Expanded(
              child: _buildSocialButton(
                onTap: () {
                  // TODO: Implement Google login
                },
                child: _buildGoogleIcon(),
              ),
            ),

            const SizedBox(width: 11),

            // Facebook Button
            Expanded(
              child: _buildSocialButton(
                onTap: () {
                  // TODO: Implement Facebook login
                },
                child: _buildFacebookIcon(),
              ),
            ),

            const SizedBox(width: 11),

            // Apple Button
            Expanded(
              child: _buildSocialButton(
                onTap: () {
                  // TODO: Implement Apple login
                },
                child: _buildAppleIcon(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: ColorPalette.socialButtonBg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Colors.transparent, width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/google_icon.svg',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildFacebookIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/facebook_icon.svg',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAppleIcon() {
    return SizedBox(
      width: 20,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/apple_icon.svg',
        width: 20,
        height: 24,
        fit: BoxFit.contain,
      ),
    );
  }
}
