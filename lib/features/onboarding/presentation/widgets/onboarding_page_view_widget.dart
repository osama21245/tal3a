import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/utils/animation_helper.dart';
import '../ui_models/onboarding_data.dart' as models;
import '../controllers/onboarding_controller.dart';
import 'onboarding_card_widget.dart';

class OnboardingPageViewWidget extends StatelessWidget {
  final PageController pageController;
  final List<models.OnboardingData> onboardingData;
  final VoidCallback? onConfettiTrigger;

  const OnboardingPageViewWidget({
    super.key,
    required this.pageController,
    required this.onboardingData,
    this.onConfettiTrigger,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: Dimensions.shadowBlur,
            offset: const Offset(0, Dimensions.shadowOffset),
            spreadRadius: Dimensions.shadowSpread,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        child: PageView.builder(
          controller: pageController,
          onPageChanged: (index) {
            context.read<OnboardingController>().updateCurrentPage(index);
          },
          itemCount: onboardingData.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: OnboardingCardWidget(
                    data: onboardingData[index],
                    index: index,
                    pageController: pageController,
                    onConfettiTrigger: onConfettiTrigger,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
