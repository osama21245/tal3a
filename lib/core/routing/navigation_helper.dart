import 'package:flutter/material.dart';
import 'package:tal3a/features/activites/presentation/controllers/training_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_cubit.dart';
import 'routes.dart';

class NavigationHelper {
  // Navigation methods for easy use throughout the app

  // Authentication Navigation
  static void goToSignIn(BuildContext context) {
    Navigator.pushNamed(context, Routes.signInScreen);
  }

  static void goToSignUp(BuildContext context) {
    Navigator.pushNamed(context, Routes.signUpScreen);
  }

  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, Routes.forgotPasswordScreen);
  }

  static void goToChooseVerificationWay(BuildContext context) {
    Navigator.pushNamed(context, Routes.chooseVerificationWayScreen);
  }

  static void goToOtpVerification(
    BuildContext context, {
    required String email,
  }) {
    Navigator.pushNamed(
      context,
      Routes.otpVerificationScreen,
      arguments: email,
    );
  }

  static void goToNewPassword(BuildContext context, {required String email}) {
    Navigator.pushNamed(context, Routes.newPasswordScreen, arguments: email);
  }

  static void goToSelectWeight(BuildContext context) {
    Navigator.pushNamed(context, Routes.selectWeightScreen);
  }

  // Activities Navigation
  static void goToChooseTal3aType(BuildContext context) {
    Navigator.pushNamed(context, Routes.chooseTal3aTypeScreen);
  }

  static void goToTrainingChooseCoach(BuildContext context) {
    Navigator.pushNamed(context, Routes.trainingChooseCoachScreen);
  }

  static void goToTrainingChooseMode(
    BuildContext context, {
    required TrainingCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.trainingChooseModeScreen,
      arguments: cubit,
    );
  }

  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.homeScreen,
      (route) => false,
    );
  }

  static void goToTraining(
    BuildContext context, {
    required TrainingCubit cubit,
  }) {
    Navigator.pushNamed(context, Routes.trainingScreen, arguments: cubit);
  }

  // Walk Navigation
  static void goToWalkChooseType(BuildContext context) {
    Navigator.pushNamed(context, Routes.walkChooseTypeScreen);
  }

  static void goToWalkChooseGender(
    BuildContext context, {
    required WalkCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.walkChooseGenderScreen,
      arguments: cubit,
    );
  }

  static void goToWalkChooseFriend(
    BuildContext context, {
    required WalkCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.walkChooseFriendScreen,
      arguments: cubit,
    );
  }

  static void goToWalkChooseTime(
    BuildContext context, {
    required WalkCubit cubit,
  }) {
    Navigator.pushNamed(context, Routes.walkChooseTimeScreen, arguments: cubit);
  }

  static void goToWalkGroupChooseType(
    BuildContext context, {
    required WalkCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.walkGroupChooseTypeScreen,
      arguments: cubit,
    );
  }

  static void goToWalkGroupChooseLocation(
    BuildContext context, {
    required WalkCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.walkGroupChooseLocationScreen,
      arguments: cubit,
    );
  }

  static void goToWalkGroupChooseTime(
    BuildContext context, {
    required WalkCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.walkGroupChooseTimeScreen,
      arguments: cubit,
    );
  }

  // Biking Navigation
  static void goToBikingChooseType(BuildContext context) {
    Navigator.pushNamed(context, Routes.bikingChooseTypeScreen);
  }

  static void goToBikingChooseGender(
    BuildContext context, {
    required BikingCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.bikingChooseGenderScreen,
      arguments: cubit,
    );
  }

  static void goToBikingChooseFriend(
    BuildContext context, {
    required BikingCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.bikingChooseFriendScreen,
      arguments: cubit,
    );
  }

  static void goToBikingChooseTime(
    BuildContext context, {
    required BikingCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.bikingChooseTimeScreen,
      arguments: cubit,
    );
  }

  static void goToBikingGroupChooseType(
    BuildContext context, {
    required BikingCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.bikingGroupChooseTypeScreen,
      arguments: cubit,
    );
  }

  static void goToBikingGroupChooseLocation(
    BuildContext context, {
    required BikingCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.bikingGroupChooseLocationScreen,
      arguments: cubit,
    );
  }

  static void goToBikingGroupChooseTime(
    BuildContext context, {
    required BikingCubit cubit,
  }) {
    Navigator.pushNamed(
      context,
      Routes.bikingGroupChooseTimeScreen,
      arguments: cubit,
    );
  }

  // Utility Navigation Methods
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void goBackWithResult(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  static void pushAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  static void pushReplacement(
    BuildContext context,
    String routeName, {
    dynamic arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }
}
