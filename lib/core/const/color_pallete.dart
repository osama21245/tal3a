import 'package:flutter/material.dart';

class ColorPalette {
  // Primary Colors (from Figma)
  static const Color primaryBlue = Color(0xFF2BB8FF);
  static const Color secondaryBlue = Color(0xFF00AAFF);
  static const Color black = Color(0xFF000000);
  static const Color darkBlue = Color(0xFF0088CC);

  // Background Colors (from Figma)
  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFE7EAEC);
  static const Color cardGrey = Color(0xFFFAFAFA); // Updated to match Figma
  static const Color cardGreySecondary = Color(0xFFE8EAED);
  static const Color socialButtonBg = Color(0xFFE6F7FF); // Social login buttons
  static const Color forgotPasswordBg = Color(
    0xFF081E29,
  ); // Forgot password background

  // Text Colors (from Figma)
  static const Color textDark = Color(0xFF354F5C);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFA1A0A1); // Subtitle text
  static const Color textPlaceholder = Color(0xFF72848D); // Input placeholder
  static const Color textOr = Color(0xFFB1B8BE); // "or" text

  // Progress Indicator Colors
  static const Color progressInactive = Color(
    0xFF354F5C,
  ); // Inactive progress step

  // Indicator Colors
  static const Color indicatorActive = Color(0xFF2BB8FF);
  static const Color indicatorInactive = Color(0xFF2C2C2C);

  // Button Colors
  static const Color buttonGradientStart = Color(0xFF2BB8FF);
  static const Color buttonGradientEnd = Color(0xFF00AAFF);

  // Shadow Colors
  static const Color shadowLight = Color(0xFFF7F7F7);
  static const Color shadowDark = Color(0xFFE8E8E8);

  // Divider Colors (from Figma)
  static const Color dividerColor = Color(0xFFEDF0F2);

  // Success Colors
  static const Color successGreen = Color(0xFF00C566);

  // More Data Screen Colors (from Figma)
  static const Color neutral50 = Color(0xFFFAFAFA); // Input field background
  static const Color textLightGrey = Color(0xFF72848D); // Placeholder text
  static const Color borderLight = Color(0xFFE7EAEB); // Light border

  // My Interests Screen Colors (from Figma)
  static const Color interestCardBg = Color(
    0xFFF3F3F4,
  ); // Interest card background
  static const Color interestCardSelected = Color(
    0xFF00AAFF,
  ); // Selected interest card
  static const Color interestTextGrey = Color(
    0xFF9BA8AF,
  ); // Interest text color
  static const Color interestTextWhite = Color(
    0xFFFFFFFF,
  ); // Selected interest text
  static const Color progressActive = Color(0xFF2BB8FF); // Active progress bar
  static const Color progressInactiveGrey = Color(
    0xFF354F5C,
  ); // Inactive progress bar

  // Select Weight Screen Colors (from Figma)
  static const Color unitToggleBg = Color(0xFFF3F3F4); // Unit toggle background
  static const Color unitToggleActive = Color(0xFF00AAFF); // Active unit toggle
  static const Color unitToggleInactive = Color(
    0xFF676C75,
  ); // Inactive unit toggle text
  static const Color weightHeightInputBg = Color(
    0xFFFAFAFA,
  ); // Input field background

  // Choose Tal3a Type Screen Colors (from Figma)
  static const Color activityCardBg = Color(
    0xFFF3F3F4,
  ); // Activity card background
  static const Color activityCardSelected = Color(
    0xFF00AAFF,
  ); // Selected activity card
  static const Color activityTextGrey = Color(
    0xFF9BA8AF,
  ); // Activity text color
  static const Color activityTextWhite = Color(
    0xFFFFFFFF,
  ); // Selected activity text

  // Training Tal3a Type Screen Colors (from Figma)
  static const Color coachCardBg = Color(0xFFFAFAFA); // Coach card background
  static const Color coachCardSelected = Color(
    0xFF00AAFF,
  ); // Selected coach card
  static const Color coachNameText = Color(
    0xFFFFFFFF,
  ); // Coach name text (selected)
  static const Color coachNameTextUnselected = Color(
    0xFF0C2B3B,
  ); // Coach name text (unselected)
  static const Color coachTitleText = Color(0xFF0C2B3B); // Coach title text
  static const Color coachTitleTextSelected = Color(
    0xFFFFFFFF,
  ); // Coach title text (selected)
  static const Color ratingBg = Color(
    0x33FFFFFF,
  ); // Rating background (20% opacity white)
  static const Color ratingText = Color(0xFFEEA811); // Rating text color
  static const Color starColor = Color(0xFFF1B739); // Star color
  static const Color tal3aTypeBg = Color(0xFF00AAFF); // Tal3a type background
  static const Color tal3aTypeText = Color(0xFFFFFFFF); // Tal3a type text
  static const Color trainingHeaderBg = Color(
    0xFF0C2B3B,
  ); // Training header background

  // Training Page Colors (from Figma)
  static const Color trainingSessionBg = Color(
    0xFFEEF2F5,
  ); // Session background
  static const Color trainingSessionLocked = Color(
    0xFF72848D,
  ); // Locked session text
  static const Color trainingSessionUnlocked = Color(
    0xFF0C2B3B,
  ); // Unlocked session text
  static const Color trainingBookmark = Color(0xFFEEA811); // Bookmark color
  static const Color trainingRating = Color(0xFFF1B739); // Rating star color
  static const Color trainingDescription = Color(
    0xFF9BA8AF,
  ); // Description text
  static const Color videoOverlay = Color(
    0x80000000,
  ); // Video overlay (50% black)
  static const Color videoProgressBg = Color(
    0x4DFFFFFF,
  ); // Video progress background (30% white)
  static const Color videoProgress = Color(0xFFFFFFFF); // Video progress bar
  static const Color videoControlsBg = Color(
    0x00000000,
  ); // Video controls background (transparent)
  static const Color goToHomeButton = Color(0xFF00AAFF); // Go to home button
  static const Color goToHomeButtonBorder = Color(
    0xFF00AAFF,
  ); // Go to home button border

  // Walk Friend Selection Colors (from Figma)
  static const Color friendCardSelected = Color(
    0xFF00AAFF,
  ); // Selected friend card background
  static const Color friendCardUnselected = Color(
    0xFFF2F5F6,
  ); // Unselected friend card background
  static const Color friendCardTextSelected = Color(
    0xFFFFFFFF,
  ); // Selected friend card text
  static const Color friendCardTextUnselected = Color(
    0xFF0C2B3B,
  ); // Unselected friend card text
  static const Color friendCardIconGrey = Color(
    0xFF9BA8AF,
  ); // Friend card placeholder icon

  // Group Flow Colors (from Figma)
  static const Color locationMarkerBg = Color(
    0xFF96DCFF,
  ); // Location marker background
  static const Color warningColor = Color(0xFFEEA811); // Warning text color
  static const Color calendarDayText = Color(
    0xFF354F5C,
  ); // Calendar day text color

  // Home Screen Colors (from Figma)
  static const Color homeHeaderBg = Color(
    0xFF0C2B3B,
  ); // Dark blue header background
  static const Color homeMainBg = Color(
    0xFFFAFAFA,
  ); // Light grey main background
  static const Color homeTabBg = Color(0xFFFAFAFA); // Tab background
  static const Color homeTabActive = Color(0xFF2BB8FF); // Active tab color
  static const Color homeTabInactive = Color(0xFF354F5C); // Inactive tab color
  static const Color homeTabActiveBg = Color(
    0xFF2BB8FF,
  ); // Active tab background
  static const Color homeTabInactiveBg = Color(
    0xFFFFFFFF,
  ); // Inactive tab background
  static const Color homeNotificationBg = Color(
    0xFFFFFFFF,
  ); // Notification button background
  static const Color homeProfileBorder = Color(
    0xFF2BB8FF,
  ); // Profile picture border
  static const Color homeActivityBorder = Color(
    0xFF636363,
  ); // Activity circle border

  // Settings Screen Colors (from Figma)
  static const Color settingsHeaderBg = Color(
    0xFF0C2B3B,
  ); // Settings header background
  static const Color settingsMainBg = Color(
    0xFFFFFFFF,
  ); // Settings main background
  static const Color settingsTabBg = Color(
    0xFFFAFAFA,
  ); // Settings tab background
  static const Color settingsTabActiveBg = Color(
    0xFF2BB8FF,
  ); // Active tab background
  static const Color settingsTabInactiveBg = Color(
    0xFFFFFFFF,
  ); // Inactive tab background
  static const Color settingsTabActiveText = Color(
    0xFFFFFFFF,
  ); // Active tab text
  static const Color settingsTabInactiveText = Color(
    0xFF354F5C,
  ); // Inactive tab text
  static const Color settingsProfileCardBg = Color(
    0xFFFFFFFF,
  ); // Profile card background
  static const Color settingsProfileBorder = Color(
    0xFF00AAFF,
  ); // Profile picture border
  static const Color settingsProfileNameText = Color(
    0xFF232027,
  ); // Profile name text
  static const Color settingsProfileEmailText = Color(
    0xFFAAAAAA,
  ); // Profile email text
  static const Color settingsStarBg = Color(0xFFEEA811); // Star background
  static const Color settingsStarColor1 = Color(0xFFF8DB9D); // Star color 1
  static const Color settingsStarColor2 = Color(0xFFF5CD75); // Star color 2
  static const Color settingsEditButtonBg = Color(
    0xFF00AAFF,
  ); // Edit button background
  static const Color settingsMenuItemBg = Color(
    0xFFFFFFFF,
  ); // Menu item background
  static const Color settingsMenuItemIconBg = Color(
    0xFFE6F7FF,
  ); // Menu item icon background
  static const Color settingsMenuItemText = Color(0xFF48454B); // Menu item text
  static const Color settingsMenuItemTextDark = Color(
    0xFF0C2B3B,
  ); // Menu item text dark
  static const Color settingsToggleActive = Color(
    0xFF00AAFF,
  ); // Toggle active color
  static const Color settingsToggleInactive = Color(
    0xFFFFFFFF,
  ); // Toggle inactive color
  static const Color settingsLogoutText = Color(
    0xFFDA0B20,
  ); // Logout text color
  static const Color homeActivityBorderGreen = Color(
    0xFF4CA821,
  ); // Green activity border
  static const Color homeActivityBorderBlue = Color(
    0xFF009DFF,
  ); // Blue activity border
  static const Color homeActivityBorderYellow = Color(
    0xFFFFE600,
  ); // Yellow activity border
  static const Color homeActivityBorderDark = Color(
    0xFF0906A1,
  ); // Dark blue activity border
  static const Color homeBottomNavBg = Color(
    0xFFFAFAFA,
  ); // Bottom navigation background
  static const Color homeIndicatorBg = Color(
    0xFF1A181A,
  ); // Home indicator background
  static const Color homeActiveDot = Color(0xFF00AAFF); // Active tab dot

    // Tal3a Vibes Colors (from Figma)
  static const Color tal3aVibesHeaderBg = Color(
    0xFF0C2B3B,
  );
}
