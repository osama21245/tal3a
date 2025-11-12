import 'package:flutter/material.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/const/text_style.dart';
import '../widgets/select_more_data_screen/select_more_data_form_widget.dart';

class SelectMoreDataScreen extends StatelessWidget {
  const SelectMoreDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Full background with exact Figma color - Same as forgot password
          Container(
            height: screenHeight,
            width: double.infinity,
            color: ColorPalette.forgotPasswordBg,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Top padding
                  // Back Button - Exact same as forgot password
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/back_button.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Title - Same as forgot password
                  Text(
                    'Create an account',
                    style: const TextStyle(
                      color: ColorPalette.textWhite,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      height: 1.6,
                      letterSpacing: 0.75,
                      fontFamily: 'Rubik',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Progress Indicators - Same as forgot password
                  Row(
                    children: [
                      // First step (completed)
                      Container(
                        width: 118,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ColorPalette.primaryBlue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Second step (current)
                      Container(
                        width: 118,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ColorPalette.primaryBlue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Third step (inactive)
                      Container(
                        width: 118,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ColorPalette.progressInactive,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // Form Overlay - Same pattern as other screens
          Positioned(
            top: screenHeight * 0.25 - 24, // Overlap by 24px
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: ColorPalette.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Screen-specific widgets
                    const SelectMoreDataFormWidget(),

                    const SizedBox(height: Dimensions.spacingMedium),

                    // Continue Button - Same as other screens
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: ColorPalette.primaryBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: AppTextStyles.continueButtonTextStyle,
                        ),
                      ),
                    ),

                    const SizedBox(height: Dimensions.spacingMedium),

                    // Home Indicator - Same as other screens
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Container(
                          width: 150,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A181A),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
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
