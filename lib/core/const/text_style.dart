import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_pallete.dart';

class AppTextStyles {
  // Title Styles
  static TextStyle get titleStyle => TextStyle(
    color: ColorPalette.textWhite,
    fontSize: 25.h,
    fontWeight: FontWeight.bold,
    height: 1.6,
    letterSpacing: 0.75,
    fontFamily: 'Rubik',
  );

  // Description Styles
  static TextStyle get descriptionStyle => const TextStyle(
    color: ColorPalette.textWhite,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.28,
    letterSpacing: 0.48,
    fontFamily: 'Rubik',
  );

  // Language Selector Styles
  static TextStyle get languageSelectorStyle => TextStyle(
    color: ColorPalette.textDark,
    fontSize: 14.h,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
  );

  // Button Styles
  static TextStyle get buttonStyle => const TextStyle(
    color: ColorPalette.textWhite,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
  );

  // Sign-in specific styles (from Figma)
  static TextStyle get signinSubtitleStyle => const TextStyle(
    color: ColorPalette.textGrey,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    height: 1.11,
    letterSpacing: 0.54,
    fontFamily: 'Corporate S Pro',
  );

  static TextStyle get inputPlaceholderStyle => const TextStyle(
    color: ColorPalette.textPlaceholder,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.875,
    letterSpacing: 0.48,
    fontFamily: 'Rubik',
  );

  static TextStyle get forgotPasswordStyle => const TextStyle(
    color: ColorPalette.textPlaceholder,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.25,
    letterSpacing: 0.48,
    fontFamily: 'Corporate S Pro',
  );

  static TextStyle get orTextStyle => const TextStyle(
    color: ColorPalette.textOr,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    fontFamily: 'Inter',
  );

  static TextStyle get tabButtonStyle => const TextStyle(
    color: ColorPalette.textWhite,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.54,
    fontFamily: 'Rubik',
  );

  static TextStyle get tabButtonInactiveStyle => const TextStyle(
    color: ColorPalette.textDark,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.54,
    fontFamily: 'Rubik',
  );

  // Form-specific styles
  static TextStyle get formDescriptionStyle => const TextStyle(
    color: Color(0xFF2B2B2B),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.875,
    letterSpacing: 0.48,
    fontFamily: 'Rubik',
  );

  static TextStyle get formInputTextStyle => const TextStyle(
    color: ColorPalette.textDark,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 0,
    letterSpacing: 0.48,
    fontFamily: 'Rubik',
  );

  static TextStyle get formHintTextStyle => const TextStyle(
    color: Color(0xFF72848D),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.875,
    letterSpacing: 0.48,
    fontFamily: 'Rubik',
  );

  // OTP-specific styles
  static TextStyle get otpInputTextStyle => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2B2B2B),
    fontFamily: 'Inter',
    height: 1.0,
  );

  static TextStyle get otpInputErrorTextStyle => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFFDA0B20),
    fontFamily: 'Inter',
    height: 1.0,
  );

  static TextStyle get otpHintTextStyle => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFFD2D9DE),
    fontFamily: 'Inter',
    height: 1.0,
  );

  static TextStyle get resendCodeTextStyle => const TextStyle(
    color: ColorPalette.primaryBlue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.5,
    fontFamily: 'Inter',
  );

  // Login form specific styles
  static TextStyle get loginInputTextStyle => const TextStyle(
    color: ColorPalette.textDark,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 0,
    letterSpacing: 0.48,
    fontFamily: 'Rubik',
  );

  // Social login specific styles
  static TextStyle get socialOrTextStyle => const TextStyle(
    color: Color(0xFFB1B9BE), // Figma color: #B1B9BE
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    fontFamily: 'Inter',
  );

  // Verification form specific styles
  static TextStyle get verificationOptionTitleStyle => const TextStyle(
    color: Color(0xFF111111),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Plus Jakarta Sans',
    height: 1.5, // 24px line height
    letterSpacing: 0.08,
  );

  static TextStyle get verificationOptionSubtitleStyle => const TextStyle(
    color: Color(0xFF78828A),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  // Gender Screen Text Styles
  static TextStyle get genderQuestionStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 25,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 1.6, // 40px line height
    letterSpacing: 0.75,
  );

  static TextStyle get genderOptionStyle => const TextStyle(
    color: Color(0xFF111214),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Work Sans',
    height: 1.0,
    letterSpacing: -0.048,
  );

  // More Data Screen Text Styles (from Figma)
  static TextStyle get moreDataTitleStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 25,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 1.6, // 40px line height
    letterSpacing: 0.75,
  );

  static TextStyle get fieldLabelStyle => const TextStyle(
    color: Color(0xFF72848D),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get inputTextStyle => const TextStyle(
    color: Color(0xFF72848D),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get continueButtonTextStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  // My Interests Screen Text Styles (from Figma)
  static TextStyle get interestsTitleStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 25,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 1.6, // 40px line height
    letterSpacing: 0.75,
  );

  static TextStyle get interestsSubtitleStyle => const TextStyle(
    color: Color(0xFF080808),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get interestCardTextStyle => const TextStyle(
    color: Color(0xFF9BA8AF),
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get interestCardSelectedTextStyle => TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16.h,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  // Select Weight Screen Text Styles (from Figma)
  static TextStyle get weightHeightQuestionStyle => const TextStyle(
    color: Color(0xFF111214),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get weightHeightInputStyle => const TextStyle(
    color: Color(0xFF72848D),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get unitToggleActiveStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 0.94, // 15px line height
    letterSpacing: 0.48,
  );

  static TextStyle get unitToggleInactiveStyle => const TextStyle(
    color: Color(0xFF676C75),
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 0.94, // 15px line height
    letterSpacing: 0.48,
  );

  // Choose Tal3a Type Screen Text Styles (from Figma)
  static TextStyle get activityTypeTitleStyle => const TextStyle(
    color: Color.fromARGB(255, 0, 0, 0),
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rubik',
    height: 1.6, // 40px line height
    letterSpacing: 0.75,
  );

  static TextStyle get activityCardTextStyle => const TextStyle(
    color: Color(0xFF9BA8AF),
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get activityCardSelectedTextStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  // Training Tal3a Type Screen Text Styles (from Figma)
  static TextStyle get trainingTitleStyle => TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 25.h,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 1.6, // 40px line height
    letterSpacing: 0.75,
  );

  static TextStyle get coachSelectionTitleStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 25,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 1.6, // 40px line height
    letterSpacing: 0.75,
  );

  static TextStyle get tal3aTypeLabelStyle => TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18.h,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get tal3aTypeTextStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 7.65,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.88, // 14.35px line height
    letterSpacing: 0.23,
  );

  static TextStyle get coachNameStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  static TextStyle get coachNameUnselectedStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  static TextStyle get coachTitleStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 10,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 2.0, // 20px line height
    letterSpacing: 0.3,
  );

  static TextStyle get coachTitleSelectedStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 10,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 2.0, // 20px line height
    letterSpacing: 0.3,
  );

  static TextStyle get ratingTextStyle => const TextStyle(
    color: Color(0xFFEEA811),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  // Coach name concatenated text styles (different weights)
  static TextStyle get coachNameBoldStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 14,
    fontWeight: FontWeight.w700, // Bold for main name
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  static TextStyle get coachNameLightStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 14,
    fontWeight: FontWeight.w300, // Light for prefix/suffix
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  // Training Page Text Styles (from Figma)
  static TextStyle get trainingCourseTitleStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 25,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 1.6, // 40px line height
    letterSpacing: 0.75,
  );

  static TextStyle get trainingSessionTitleStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 17.125,
    fontWeight: FontWeight.w400,
    fontFamily: 'Satoshi',
    height: 1.35,
    letterSpacing: -0.34,
  );

  static TextStyle get trainingSessionTitleLockedStyle => const TextStyle(
    color: Color(0xFF72848D),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get trainingSessionDurationStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 17.125,
    fontWeight: FontWeight.w400,
    fontFamily: 'Satoshi',
    height: 1.35,
    letterSpacing: -0.34,
  );

  static TextStyle get trainingSessionDurationLockedStyle => const TextStyle(
    color: Color(0xFF72848D),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get trainingRatingStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get trainingDurationStyle => const TextStyle(
    color: Color(0xFF72848D),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.875, // 30px line height
    letterSpacing: 0.48,
  );

  static TextStyle get trainingDescriptionStyle => const TextStyle(
    color: Color(0xFF9BA8AF),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Rubik',
    height: 1.785, // 25px line height
    letterSpacing: 0.42,
  );

  static TextStyle get videoTimeStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 14.56,
    fontWeight: FontWeight.w300,
    fontFamily: 'Arial',
    height: 1.714,
  );

  static TextStyle get goToHomeButtonStyle => const TextStyle(
    color: Color(0xFF00AAFF),
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Rubik',
    height: 1.333,
    letterSpacing: 0.54,
  );

  static TextStyle get trainingAppBarTitleStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Rubik',
    height: 1.333,
    letterSpacing: 0.54,
  );

  static TextStyle get bodyLargeSemiboldStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Urbanist',
    height: 1.4,
    letterSpacing: 0.2,
  );

  // Walk Friend Selection Text Styles (from Figma)
  static TextStyle get friendCardNameStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get friendCardNameSelectedStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get friendCardDetailsStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get friendCardDetailsSelectedStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get friendCardUnitStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 16,
    fontWeight: FontWeight.w100,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.48,
  );

  static TextStyle get friendCardUnitSelectedStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w100,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.48,
  );

  // Home Screen Text Styles (from Figma)
  static TextStyle get homeStatusBarStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Urbanist',
    height: 1.4, // 22.4px line height
    letterSpacing: 0.2,
  );

  static TextStyle get homeDateStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Plus Jakarta Sans',
    height: 1.55, // 21.7px line height
    letterSpacing: -0.28,
  );

  static TextStyle get homeGreetingStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Plus Jakarta Sans',
    height: 1.4, // 25.2px line height
    letterSpacing: 0,
  );

  static TextStyle get homeProfileNameStyle => const TextStyle(
    color: Color(0xFFE7EAEB),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  static TextStyle get homeTabActiveStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 17,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get homeTabInactiveStyle => const TextStyle(
    color: Color(0xFF354F5C),
    fontSize: 17,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  // Settings Screen Text Styles (from Figma)
  static TextStyle get settingsAppBarTitleStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get settingsTabActiveStyle => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get settingsTabInactiveStyle => const TextStyle(
    color: Color(0xFF354F5C),
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Rubik',
    height: 1.33, // 24px line height
    letterSpacing: 0.54,
  );

  static TextStyle get settingsProfileNameStyle => const TextStyle(
    color: Color(0xFF232027),
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Rubik',
    height: 0.94, // 15px line height
    letterSpacing: 0.48,
  );

  static TextStyle get settingsProfileEmailStyle => const TextStyle(
    color: Color(0xFFAAAAAA),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  static TextStyle get settingsMenuItemStyle => const TextStyle(
    color: Color(0xFF48454B),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  static TextStyle get settingsMenuItemDarkStyle => const TextStyle(
    color: Color(0xFF0C2B3B),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );

  static TextStyle get settingsLogoutStyle => const TextStyle(
    color: Color(0xFFDA0B20),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );
    static TextStyle get tal3aVibesStoryStyle => const TextStyle(
    color: Color(0xFFE7EAEB),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Rubik',
    height: 1.43, // 20px line height
    letterSpacing: 0.42,
  );
}
