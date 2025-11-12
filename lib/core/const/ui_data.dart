import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/features/onboarding/presentation/ui_models/onboarding_data.dart';

List<OnboardingData> getOnboardingData() {
  return [
    OnboardingData(
      title: "onboarding.title_1".tr(),
      description: "onboarding.description_1".tr(),
      imagePath: "assets/images/fitness_partner.png",
    ),
    OnboardingData(
      title: "onboarding.title_2".tr(),
      description: "onboarding.description_2".tr(),
      imagePath: "assets/images/friends_step.png",
    ),
    OnboardingData(
      title: "onboarding.title_3".tr(),
      description: "onboarding.description_3".tr(),
      imagePath: "assets/images/certified_coaches.png",
    ),
  ];
}
