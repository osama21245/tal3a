# 📸 Story Upload Feature Implementation

## 🚀 Overview

The story upload feature has been implemented following the project's established patterns and guidelines. It integrates with the API endpoint `{{baseURL}}/api/v1/user/uploadStories` and supports uploading images with text notes.

## 📁 Files Created/Modified

### New Files Created:
- `lib/features/story/data/models/story_upload_request_model.dart`
- `lib/features/story/data/models/story_upload_response_model.dart`
- `lib/features/story/data/data_sources/story_data_source.dart`
- `lib/features/story/data/repositories/story_repository_impl.dart`

### Modified Files:
- `lib/core/network/api_client.dart` - Added multipart upload method
- `lib/core/constants/api_constants.dart` - Added uploadStories endpoint
- `lib/features/story/presentation/controllers/story_state.dart` - Added upload states
- `lib/features/story/presentation/controllers/story_cubit.dart` - Added upload functionality
- `lib/features/story/presentation/widgets/add_comment_screen/add_comment_form_widget.dart` - Integrated upload

## 🔧 API Integration

### Endpoint
```
POST {{baseURL}}/api/v1/user/uploadStories
```

### Request Body (Multipart Form Data)
- `images`: File (image file)
- `note`: String (text note)

### Response
```json
{
  "success": true,
  "message": "Story uploaded successfully",
  "storyId": "story_id_here",
  "imageUrl": "uploaded_image_url"
}
```

## 🎯 Usage

### 1. Basic Upload
```dart
final cubit = context.read<StoryCubit>();
final imageFile = File('path/to/image.jpg');
final note = 'My story text';

cubit.uploadStory(imageFile, note);
```

### 2. Listening to Upload States
```dart
BlocBuilder<StoryCubit, StoryState>(
  builder: (context, state) {
    if (state.isUploadingStory) {
      return CircularProgressIndicator();
    }
    
    if (state.isStoryUploaded) {
      // Handle successful upload
      return Text('Story uploaded successfully!');
    }
    
    if (state.uploadError != null) {
      // Handle upload error
      return Text('Error: ${state.uploadError}');
    }
    
    return UploadButton();
  },
)
```

### 3. Navigation with Shared Cubit
```dart
// Create cubit once
final storyCubit = StoryCubit();

// Navigate to camera with shared cubit
StoryNavigation.toCamera(context, storyCubit);

// Navigate to add comment with same cubit
StoryNavigation.toAddComment(context, storyCubit);

// Upload will use the same cubit instance
```

## 🎨 UI Integration

The upload functionality is integrated into the existing story flow:

1. **Camera Screen** → Take/Select Photo
2. **Add Comment Screen** → Add text note
3. **Upload** → Automatically uploads when "Post Story" is pressed
4. **View Story** → Navigate to view the uploaded story

### Loading States
- Upload button shows loading spinner during upload
- Button is disabled during upload
- Error messages displayed via SnackBar

## 🔄 State Management

### New State Properties
- `isUploadingStory`: Boolean indicating upload in progress
- `isStoryUploaded`: Boolean indicating successful upload
- `uploadError`: String containing error message if upload fails

### State Flow
1. User taps "Post Story"
2. `isUploadingStory` = true
3. API call made
4. On success: `isStoryUploaded` = true
5. On error: `uploadError` = error message

## 🛠️ Technical Implementation

### Architecture Pattern
Following the project's clean architecture:
- **Models**: Request/Response data structures
- **Data Source**: API communication layer
- **Repository**: Business logic layer
- **Cubit**: State management
- **UI**: Presentation layer

### Error Handling
- Network errors caught and displayed
- API response errors handled gracefully
- Fallback to local story creation if upload fails

### File Upload
- Uses multipart form data
- Supports image files (JPEG by default)
- Automatic content-type detection
- File existence validation

## 🚨 Important Notes

1. **Single Cubit Pattern**: As requested, the same `StoryCubit` instance is passed between screens using `BlocProvider.value` to maintain state consistency.

2. **No MultiBloc**: The implementation avoids using `MultiBlocProvider` and instead passes the same cubit instance through navigation.

3. **Error Fallback**: If upload fails, the system falls back to local story creation to ensure user experience isn't broken.

4. **Memory Management**: File references are properly managed to avoid memory leaks.

## 🔗 Dependencies

- `dart:io` - File handling
- `flutter_bloc` - State management
- `http` - API communication
- `http_parser` - Multipart form data

## 📱 User Experience

1. User takes/selects photo
2. User adds text comment
3. User taps "Post Story"
4. Loading indicator shows
5. Story uploads to server
6. Success: Navigate to view story
7. Error: Show error message, allow retry

## 🎯 Next Steps

To extend this functionality:
1. Add progress indicators for upload progress
2. Implement retry mechanism for failed uploads
3. Add support for multiple images
4. Implement story editing functionality
5. Add story deletion from server

## 📞 Support

For questions or issues with the story upload feature, refer to the existing story navigation patterns and the established project architecture.
