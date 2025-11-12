# 📱 Story Feature - Navigation Guide

## 🚀 Quick Start

To access the story feature from anywhere in your app, use:

```dart
import 'package:tal3a/features/story/presentation/utils/story_navigation.dart';

// Navigate to main story screen
StoryNavigation.toMainStory(context);
```

## 🗺️ Navigation Routes

### Available Routes
- `/storyMain` - Main story screen with stories list
- `/storyCamera` - Camera screen with filters
- `/storyPhotoSelection` - Photo selection from gallery
- `/storyAddComment` - Add text to story
- `/storyViewOwn` - View your own stories
- `/storyViewOthers` - View others' stories

### Navigation Methods

#### 1. **Main Story Screen**
```dart
StoryNavigation.toMainStory(context);
```

#### 2. **Camera Flow**
```dart
// Start camera
StoryNavigation.toCamera(context, storyCubit);

// Go to photo selection
StoryNavigation.toPhotoSelection(context, storyCubit);
```

#### 3. **Story Creation Flow**
```dart
// Add comment to story
StoryNavigation.toAddComment(context, storyCubit);

// View created story (replaces current screen)
StoryNavigation.replaceWithViewOwnStory(context, storyCubit);
```

#### 4. **Story Viewing**
```dart
// View own stories
StoryNavigation.toViewOwnStory(context, storyCubit);

// View others' stories
StoryNavigation.toViewOthersStory(context, storyCubit);
```

#### 5. **Navigation Control**
```dart
// Go back
StoryNavigation.pop(context);

// Pop to main story
StoryNavigation.popToMainStory(context);

// Go to home
StoryNavigation.toHome(context);
```

## 🎯 Integration Examples

### 1. **Add Story Button to Any Screen**
```dart
import 'package:tal3a/features/story/presentation/widgets/story_fab.dart';

Scaffold(
  body: YourContent(),
  floatingActionButton: const StoryFAB(),
)
```

### 2. **Add Story Menu Item**
```dart
ListTile(
  leading: const Icon(Icons.add_a_photo),
  title: const Text('Add Story'),
  onTap: () => StoryNavigation.toMainStory(context),
)
```

### 3. **Navigation from Bottom Navigation**
```dart
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_a_photo),
      label: 'Stories',
    ),
  ],
  onTap: (index) {
    if (index == 1) {
      StoryNavigation.toMainStory(context);
    }
  },
)
```

## 🔄 Complete User Flow

### Story Creation Flow:
1. **Start** → `StoryNavigation.toMainStory(context)`
2. **Tap "Add Story"** → `StoryNavigation.toCamera(context, cubit)`
3. **Take/Select Photo** → `StoryNavigation.toPhotoSelection(context, cubit)`
4. **Add Comment** → `StoryNavigation.toAddComment(context, cubit)`
5. **View Story** → `StoryNavigation.replaceWithViewOwnStory(context, cubit)`

### Story Viewing Flow:
1. **From Main** → `StoryNavigation.toViewOwnStory(context, cubit)`
2. **Or View Others** → `StoryNavigation.toViewOthersStory(context, cubit)`

## 🎨 State Management

### StoryCubit Usage
```dart
// Create cubit
final storyCubit = StoryCubit()..loadStories();

// Pass to navigation
StoryNavigation.toCamera(context, storyCubit);

// Or use BlocProvider
BlocProvider(
  create: (context) => StoryCubit()..loadStories(),
  child: YourWidget(),
)
```

## 🔧 Customization

### Custom Navigation
```dart
// Custom route with arguments
Navigator.of(context).pushNamed(
  Routes.storyCameraScreen,
  arguments: storyCubit,
);

// Custom replacement
Navigator.of(context).pushReplacementNamed(
  Routes.storyViewOwnScreen,
  arguments: storyCubit,
);
```

## 📱 Screen Structure

Each screen follows the established pattern:
- **Screen File**: Contains the main screen widget
- **Form Widget**: Contains the screen content
- **Navigation**: Uses `StoryNavigation` utility
- **State Management**: Uses `StoryCubit`

## 🚨 Important Notes

1. **Always pass StoryCubit** to maintain state across screens
2. **Use replaceWith methods** when completing a flow (e.g., after creating story)
3. **Use pop methods** when going back in a flow
4. **Use toMainStory** to reset the navigation stack

## 🎯 Best Practices

1. **Consistent Navigation**: Always use `StoryNavigation` utility
2. **State Preservation**: Pass cubit between screens
3. **User Experience**: Use appropriate navigation methods (push vs replace)
4. **Error Handling**: Handle navigation errors gracefully

## 🔗 Dependencies

- `flutter_bloc` - State management
- `easy_localization` - Translations
- `flutter/material.dart` - UI components
- Custom routing system

## 📞 Support

For navigation issues or questions, refer to the routing system in `lib/core/routing/`.
