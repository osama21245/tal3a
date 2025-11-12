import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import 'package:tal3a/core/routing/routes.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/const/text_style.dart';
import '../../../../core/utils/animation_helper.dart';
import '../ui_models/onboarding_data.dart' as models;
import '../controllers/onboarding_controller.dart';

class OnboardingCardWidget extends StatelessWidget {
  final models.OnboardingData data;
  final int index;
  final PageController pageController;
  final VoidCallback? onConfettiTrigger;

  const OnboardingCardWidget({
    super.key,
    required this.data,
    required this.index,
    required this.pageController,
    this.onConfettiTrigger,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorPalette.cardGrey, ColorPalette.cardGreySecondary],
          ),
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                child: Image.asset(
                  data.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Text Content with Animations
            Positioned(
              left: Dimensions.paddingLarge,
              top: Dimensions.paddingXLarge,
              width: Dimensions.textContainerWidth.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with animation
                  AnimationHelper.onboardingTitleAnimation(
                    child: Text(data.title, style: AppTextStyles.titleStyle),
                  ),

                  const SizedBox(height: Dimensions.spacingSmall),

                  // Description with animation
                  AnimationHelper.onboardingDescriptionAnimation(
                    child: Text(
                      data.description,
                      style: AppTextStyles.descriptionStyle,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Buttons
            Positioned(
              right: Dimensions.paddingLarge,
              bottom: Dimensions.paddingLarge,
              child: AnimationHelper.onboardingNavigationAnimation(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Previous button
                    if (index > 0) _buildPreviousButton(context),

                    // Next button
                    _buildNextButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousButton(BuildContext context) {
    return Container(
      width: Dimensions.buttonWidth,
      height: Dimensions.buttonWidth,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color:
            index == 1
                ? ColorPalette.secondaryBlue.withOpacity(0.3)
                : ColorPalette.secondaryBlue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (index == 1
                    ? ColorPalette.secondaryBlue.withOpacity(0.3)
                    : ColorPalette.secondaryBlue)
                .withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          final controller = context.read<OnboardingController>();
          if (!controller.isFirstPage()) {
            pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: ColorPalette.textWhite,
          size: Dimensions.iconLarge,
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      width: Dimensions.buttonWidth,
      height: Dimensions.buttonWidth,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            ColorPalette.buttonGradientStart,
            ColorPalette.buttonGradientEnd,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.buttonGradientStart.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () async {
          final controller = context.read<OnboardingController>();
          if (!controller.isLastPage(3)) {
            // Assuming 3 pages total
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            onConfettiTrigger?.call();
            await Future.delayed(const Duration(seconds: 1), () {});
            context.read<UserController>().completeOnboarding();
            Navigator.of(context).pushReplacementNamed(Routes.signInScreen);
          }
        },
        icon: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: ColorPalette.textWhite,
          size: Dimensions.iconLarge,
        ),
      ),
    );
  }
}
