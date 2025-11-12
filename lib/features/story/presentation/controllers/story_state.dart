import '../../../story/data/models/story_model.dart';
import '../../../story/data/models/story_filter_model.dart';
import '../../../story/data/models/story_user_model.dart';
import '../../../story/data/models/story_item_model.dart';

class StoryState {
  final bool isLoading;
  final bool isError;
  final String? error;
  final List<StoryModel> stories;
  final List<StoryFilterModel> filters;
  final StoryFilterModel? selectedFilter;
  final String? selectedImagePath;
  final String? storyText;
  final bool isFlashOn;
  final bool isCameraFront;
  final bool isCreatingStory;
  final bool isStoryCreated;
  final bool isStoryDeleted;
  final bool isUploadingStory;
  final bool isStoryUploaded;
  final String? uploadError;
  final StoryModel? currentStory;
  final List<StoryUserModel> storyUsers;
  final bool isLoadingUsers;
  final List<StoryItemModel> userStories;
  final bool isLoadingUserStories;
  final String? selectedUserId;

  StoryState({
    this.isLoading = false,
    this.isError = false,
    this.error,
    this.stories = const [],
    this.filters = const [],
    this.selectedFilter,
    this.selectedImagePath,
    this.storyText,
    this.isFlashOn = false,
    this.isCameraFront = false,
    this.isCreatingStory = false,
    this.isStoryCreated = false,
    this.isStoryDeleted = false,
    this.isUploadingStory = false,
    this.isStoryUploaded = false,
    this.uploadError,
    this.currentStory,
    this.storyUsers = const [],
    this.isLoadingUsers = false,
    this.userStories = const [],
    this.isLoadingUserStories = false,
    this.selectedUserId,
  });

  StoryState copyWith({
    bool? isLoading,
    bool? isError,
    String? error,
    List<StoryModel>? stories,
    List<StoryFilterModel>? filters,
    StoryFilterModel? selectedFilter,
    String? selectedImagePath,
    String? storyText,
    bool? isFlashOn,
    bool? isCameraFront,
    bool? isCreatingStory,
    bool? isStoryCreated,
    bool? isStoryDeleted,
    bool? isUploadingStory,
    bool? isStoryUploaded,
    String? uploadError,
    StoryModel? currentStory,
    List<StoryUserModel>? storyUsers,
    bool? isLoadingUsers,
    List<StoryItemModel>? userStories,
    bool? isLoadingUserStories,
    String? selectedUserId,
  }) {
    return StoryState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      error: error ?? this.error,
      stories: stories ?? this.stories,
      filters: filters ?? this.filters,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      storyText: storyText ?? this.storyText,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isCameraFront: isCameraFront ?? this.isCameraFront,
      isCreatingStory: isCreatingStory ?? this.isCreatingStory,
      isStoryCreated: isStoryCreated ?? this.isStoryCreated,
      isStoryDeleted: isStoryDeleted ?? this.isStoryDeleted,
      isUploadingStory: isUploadingStory ?? this.isUploadingStory,
      isStoryUploaded: isStoryUploaded ?? this.isStoryUploaded,
      uploadError: uploadError ?? this.uploadError,
      currentStory: currentStory ?? this.currentStory,
      storyUsers: storyUsers ?? this.storyUsers,
      isLoadingUsers: isLoadingUsers ?? this.isLoadingUsers,
      userStories: userStories ?? this.userStories,
      isLoadingUserStories: isLoadingUserStories ?? this.isLoadingUserStories,
      selectedUserId: selectedUserId ?? this.selectedUserId,
    );
  }
}
