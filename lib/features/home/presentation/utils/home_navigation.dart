import 'package:flutter/material.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/routing/navigation_helper.dart';

class HomeNavigation {
  // Navigation methods for home screen and related functionality

  /// Navigate to home screen (clears navigation stack)
  static void toHome(BuildContext context) {
    NavigationHelper.goToHome(context);
  }

  /// Navigate to home screen (pushes on top of current screen)
  static void toHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.homeScreen);
  }

  /// Navigate to activities screen from home
  static void toActivities(BuildContext context) {
    Navigator.pushNamed(context, Routes.chooseTal3aTypeScreen);
  }

  /// Navigate to story feature from home
  static void toStory(BuildContext context) {
    Navigator.pushNamed(context, Routes.storyMainScreen);
  }

  /// Navigate to profile screen from home
  static void toProfile(BuildContext context) {
    Navigator.pushNamed(context, Routes.profileScreen);
  }

  /// Navigate to settings screen from home
  static void toSettings(BuildContext context) {
    Navigator.pushNamed(context, Routes.settingsScreen);
  }

  /// Navigate to notifications screen from home
  static void toNotifications(BuildContext context) {
    Navigator.pushNamed(context, Routes.notificationsScreen);
  }

  /// Navigate to community screen from home
  static void toCommunity(BuildContext context) {
    Navigator.pushNamed(context, Routes.communityScreen);
  }

  /// Navigate to nutrition screen from home
  static void toNutrition(BuildContext context) {
    Navigator.pushNamed(context, Routes.nutritionScreen);
  }

  /// Navigate to progress screen from home
  static void toProgress(BuildContext context) {
    Navigator.pushNamed(context, Routes.progressScreen);
  }

  /// Navigate to AiWalk Screen from home
  static void toAiWalk(BuildContext context) {
    Navigator.pushNamed(context, Routes.aiWalkMeta);
  }

  /// Pop current screen and return to home
  static void popToHome(BuildContext context) {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.homeScreen,
    );
  }

  /// Pop current screen
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
