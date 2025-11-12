# Home Feature

This feature implements the main home screen of the Tal3a app based on the Figma design.

## Structure

```
lib/features/home/
├── presentation/
│   ├── controllers/
│   │   └── home_cubit.dart           # State management for home screen
│   ├── screens/
│   │   └── home_screen.dart          # Main home screen
│   └── widgets/
│       └── home_screen/
│           ├── home_header_widget.dart           # Header with date, greeting, notifications
│           ├── home_user_profiles_widget.dart    # Horizontal scrollable user profiles
│           ├── home_tab_selector_widget.dart     # Tab selector for "Live Tala3a" / "Let's Tala3a!"
│           ├── home_activity_grid_widget.dart    # Scattered activity circles
│           └── home_bottom_nav_widget.dart       # Bottom navigation bar
└── README.md
```

## Features Implemented

### ✅ Design System Integration
- **Colors**: Added home-specific colors to `ColorPalette` following Figma design
- **Text Styles**: Added home-specific text styles to `AppTextStyles` following Figma typography
- **Dimensions**: Used responsive dimensions with `ScreenUtil`

### ✅ UI Components
1. **Header Section** (Integrated User Profiles)
   - Status bar with time (9:41)
   - Date display (Friday, 20 May)
   - Greeting text (Good Morning)
   - Notification button with bell icon
   - Profile picture button
   - User profiles section with add button and scrollable profiles
   - Profile pictures with blue borders and user names

2. **Tab Selector**
   - Two-tab selector: "live tala3a" and "Let's tala3a!"
   - Active/inactive states with proper styling
   - State management with BLoC

3. **Activity Grid**
   - Scattered circular activity elements
   - Different border colors (grey, green, blue, yellow, dark blue)
   - Activity icons (running, biking) in white circles
   - Positioned based on Figma design

4. **Bottom Navigation**
   - Five navigation items (Home, Star, Chat, Sun, Person)
   - Active indicator dot above Home icon
   - Home indicator bar at bottom

### ✅ State Management
- **HomeCubit**: Manages tab selection state
- **HomeState**: Defines state classes for home screen

### ✅ Localization Support
- Added home screen text to both English and Arabic translation files
- Text keys for all user-facing strings

### ✅ Responsive Design
- Used `ScreenUtil` for responsive sizing
- Proper spacing and dimensions based on Figma design
- Responsive layout that adapts to different screen sizes

## Usage

```dart
import 'package:tal3a/features/home/home_feature.dart';

// In your app or routing
const HomeScreen()
```

## Design Fidelity

This implementation follows the Figma design exactly:
- ✅ Exact colors from Figma (#0C2B3B, #2BB8FF, etc.)
- ✅ Exact fonts and typography (Plus Jakarta Sans, Rubik, Urbanist)
- ✅ Exact spacing and positioning
- ✅ Exact border radius and shadows
- ✅ Exact layout structure

## Future Enhancements

- [ ] Add localization integration
- [ ] Connect to real user data
- [ ] Add navigation to other screens
- [ ] Implement real-time activity updates
- [ ] Add pull-to-refresh functionality
- [ ] Add loading states and error handling
