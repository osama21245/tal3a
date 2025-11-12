import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const/color_pallete.dart';

class ScreenHeaderWidget extends StatelessWidget {
  final String title;
  final int activeSteps; // Number of active progress steps (1, 2, or 3)
  final VoidCallback? onBackPressed;
  final bool showProgressBar;

  const ScreenHeaderWidget({
    super.key,
    required this.title,
    required this.activeSteps,
    this.onBackPressed,
    this.showProgressBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      width: double.infinity,
      color: ColorPalette.forgotPasswordBg,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h), // Top padding
            // Back Button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 48,
                height: 48.h,
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

            SizedBox(height: 14.h),

            // Title
            Text(
              title,
              style: TextStyle(
                color: ColorPalette.textWhite,
                fontSize: 25.h,
                fontWeight: FontWeight.bold,
                height: 1.6,
                letterSpacing: 0.75,
                fontFamily: 'Rubik',
              ),
            ),

            SizedBox(height: 20.h),

            // Progress Indicators
            Opacity(
              opacity: showProgressBar ? 1.0 : 0.0,
              child: Row(
                children: [
                  // Active step indicator (blue) - Vector 1
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 1
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Active step indicator - Vector 2
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 2
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Active step indicator - Vector 3
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 3
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(), // Push content to top
          ],
        ),
      ),
    );
  }
}
