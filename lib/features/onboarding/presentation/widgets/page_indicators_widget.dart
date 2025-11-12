import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/utils/animation_helper.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/onboarding_state.dart';

class PageIndicatorsWidget extends StatelessWidget {
  final int totalPages;

  const PageIndicatorsWidget({super.key, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingController, OnboardingState>(
      buildWhen:
          (previous, current) =>
              previous.currentPageIndex != current.currentPageIndex,
      builder: (context, state) {
        return AnimationHelper.onboardingPageIndicatorsAnimation(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingMedium,
              vertical: Dimensions.paddingSmall,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ColorPalette.shadowLight, ColorPalette.shadowDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimensions.radiusXLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                totalPages,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: state.currentPageIndex == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        state.currentPageIndex == index
                            ? ColorPalette.indicatorActive
                            : ColorPalette.indicatorInactive.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
