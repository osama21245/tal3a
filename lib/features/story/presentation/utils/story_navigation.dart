import 'package:flutter/material.dart';
import '../../../../core/routing/routes.dart';
import '../controllers/story_cubit.dart';

class StoryNavigation {
  /// Navigate to the main story screen
  static void toMainStory(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.storyMainScreen);
  }

  /// Navigate to camera screen
  static void toCamera(BuildContext context, StoryCubit cubit) {
    Navigator.of(context).pushNamed(Routes.storyCameraScreen, arguments: cubit);
  }

  /// Navigate to photo selection screen
  static void toPhotoSelection(BuildContext context, StoryCubit cubit) {
    Navigator.of(
      context,
    ).pushNamed(Routes.storyPhotoSelectionScreen, arguments: cubit);
  }

  /// Navigate to add comment screen
  static void toAddComment(BuildContext context, StoryCubit cubit) {
    Navigator.of(
      context,
    ).pushNamed(Routes.storyAddCommentScreen, arguments: cubit);
  }

  /// Navigate to view own story screen
  static void toViewOwnStory(BuildContext context, StoryCubit cubit) {
    Navigator.of(
      context,
    ).pushNamed(Routes.storyViewOwnScreen, arguments: cubit);
  }

  /// Navigate to view others story screen
  static void toViewOthersStory(BuildContext context, StoryCubit cubit) {
    Navigator.of(
      context,
    ).pushNamed(Routes.storyViewOthersScreen, arguments: cubit);
  }

  /// Replace current route with view own story
  static void replaceWithViewOwnStory(BuildContext context, StoryCubit cubit) {
    Navigator.of(
      context,
    ).pushReplacementNamed(Routes.storyViewOwnScreen, arguments: cubit);
  }

  /// Replace current route with view others story
  static void replaceWithViewOthersStory(
    BuildContext context,
    StoryCubit cubit,
  ) {
    Navigator.of(
      context,
    ).pushReplacementNamed(Routes.storyViewOthersScreen, arguments: cubit);
  }

  /// Pop current screen and return to previous
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  /// Pop until reaching a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  /// Pop all screens and navigate to main story
  static void popToMainStory(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.storyMainScreen, (route) => false);
  }

  /// Navigate to home screen (main app)
  static void toHome(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
  }
}
