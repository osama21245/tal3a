import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:tal3a/core/const/ui_data.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import '../widgets/language_selector_widget.dart';
import '../widgets/onboarding_page_view_widget.dart';
import '../widgets/page_indicators_widget.dart';
import '../widgets/start_button_widget.dart';
import '../widgets/confetti_widget.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserController, UserControllerState>(
      listener: (context, state) {
        if (state.isSuccess && state.nextRoute != null) {
          // Navigate to the next screen after onboarding completion
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(state.nextRoute!);
          });
        } else if (state.isError) {
          // Handle error state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Something went wrong'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorPalette.white,
        body: Stack(
          children: [
            // Confetti Overlay
            ConfettiOverlayWidget(confettiController: _confettiController),

            // Main Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.paddingLarge),
                child: Column(
                  children: [
                    // Language Selector
                    AnimationHelper.titleAnimation(
                      child: const LanguageSelectorWidget(),
                    ),

                    const SizedBox(height: Dimensions.spacingMedium),

                    // Main Content Card
                    Expanded(
                      flex: 7,
                      child: AnimationHelper.onboardingPageViewAnimation(
                        child: OnboardingPageViewWidget(
                          pageController: _pageController,
                          onboardingData: getOnboardingData(),
                          onConfettiTrigger: () => _confettiController.play(),
                        ),
                      ),
                    ),

                    const SizedBox(height: Dimensions.spacingMedium),

                    // Page Indicators
                    AnimationHelper.onboardingPageIndicatorsAnimation(
                      child: PageIndicatorsWidget(
                        totalPages: getOnboardingData().length,
                      ),
                    ),

                    const SizedBox(height: Dimensions.spacingMedium),

                    // Start Button
                    AnimationHelper.onboardingNavigationAnimation(
                      child: StartButtonWidget(
                        onConfettiTrigger: () async {
                          _confettiController.play();
                          await Future.delayed(
                            const Duration(seconds: 1),
                            () {},
                          );
                          // Mark onboarding as completed and navigate
                          context.read<UserController>().completeOnboarding();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
