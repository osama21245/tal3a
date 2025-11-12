import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import '../../../story/data/models/story_model.dart';
import '../../../story/data/models/story_filter_model.dart';
import '../../../story/data/models/story_upload_request_model.dart';
import '../../../story/data/repositories/story_repository_impl.dart';
import '../../../story/data/data_sources/story_data_source.dart';
import '../../../../core/network/api_client.dart';
import 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final StoryRepositoryImpl _storyRepository;

  StoryCubit({StoryRepositoryImpl? storyRepository})
    : _storyRepository =
          storyRepository ??
          StoryRepositoryImpl(
            dataSource: StoryDataSourceImpl(apiClient: ApiClient()),
          ),
      super(StoryState());

  void loadStories() {
    emit(state.copyWith(isLoading: true, isError: false));
    try {
      // TODO: Implement API call to load stories
      final mockStories = _getMockStories();
      emit(state.copyWith(isLoading: false, stories: mockStories));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, error: e.toString()),
      );
    }
  }

  void loadUsersWithStories() {
    emit(state.copyWith(isLoadingUsers: true, isError: false));

    _storyRepository.getUsersWithStories().then((result) {
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              isLoadingUsers: false,
              isError: true,
              error: failure.message,
            ),
          );
        },
        (response) {
          if (response.status) {
            emit(
              state.copyWith(
                isLoadingUsers: false,
                storyUsers: response.allUsers,
                isError: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoadingUsers: false,
                isError: true,
                error: response.message,
              ),
            );
          }
        },
      );
    });
  }

  void loadUserStories(String userId) {
    emit(
      state.copyWith(
        isLoadingUserStories: true,
        isError: false,
        selectedUserId: userId,
      ),
    );

    _storyRepository.getUserStories(userId).then((result) {
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              isLoadingUserStories: false,
              isError: true,
              error: failure.message,
            ),
          );
        },
        (response) {
          if (response.status) {
            emit(
              state.copyWith(
                isLoadingUserStories: false,
                userStories: response.stories,
                isError: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoadingUserStories: false,
                isError: true,
                error: response.message,
              ),
            );
          }
        },
      );
    });
  }

  void loadFilters() {
    try {
      final mockFilters = _getMockFilters();
      emit(state.copyWith(filters: mockFilters));
    } catch (e) {
      emit(state.copyWith(isError: true, error: e.toString()));
    }
  }

  void selectFilter(StoryFilterModel filter) {
    final updatedFilters =
        state.filters.map((f) {
          return f.copyWith(isSelected: f.id == filter.id);
        }).toList();

    emit(state.copyWith(filters: updatedFilters, selectedFilter: filter));
  }

  void selectImage(String imagePath) {
    emit(state.copyWith(selectedImagePath: imagePath));
  }

  void updateStoryText(String text) {
    emit(state.copyWith(storyText: text));
  }

  void toggleFlash() {
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }

  void toggleCamera() {
    emit(state.copyWith(isCameraFront: !state.isCameraFront));
  }

  void createStory() {
    emit(state.copyWith(isCreatingStory: true));
    try {
      // TODO: Implement API call to create story
      final newStory = StoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user_id',
        userName: 'Current User',
        userEmail: 'current@user.com',
        imageUrl: state.selectedImagePath,
        text: state.storyText,
        createdAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          isCreatingStory: false,
          isStoryCreated: true,
          stories: [newStory, ...state.stories],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isCreatingStory: false,
          isError: true,
          error: e.toString(),
        ),
      );
    }
  }

  void uploadStory(File imageFile, String note) {
    emit(state.copyWith(isUploadingStory: true, uploadError: null));

    final request = StoryUploadRequestModel(image: imageFile, note: note);

    _storyRepository.uploadStory(request).then((result) {
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              isUploadingStory: false,
              isStoryUploaded: false,
              uploadError: failure.message,
            ),
          );
        },
        (response) {
          if (response.success) {
            emit(
              state.copyWith(
                isUploadingStory: false,
                isStoryUploaded: true,
                uploadError: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isUploadingStory: false,
                isStoryUploaded: false,
                uploadError: response.message,
              ),
            );
          }
        },
      );
    });
  }

  void deleteStory(String storyId) {
    try {
      final updatedStories =
          state.stories.where((s) => s.id != storyId).toList();
      emit(state.copyWith(stories: updatedStories, isStoryDeleted: true));
    } catch (e) {
      emit(state.copyWith(isError: true, error: e.toString()));
    }
  }

  void shareStory(String storyId) {
    // TODO: Implement story sharing functionality
    print('Sharing story: $storyId');
  }

  void likeStory(String storyId) {
    final updatedStories =
        state.stories.map((story) {
          if (story.id == storyId) {
            return story.copyWith(
              isLiked: !story.isLiked,
              likeCount:
                  story.isLiked ? story.likeCount - 1 : story.likeCount + 1,
            );
          }
          return story;
        }).toList();

    emit(state.copyWith(stories: updatedStories));
  }

  void viewStory(String storyId) {
    final updatedStories =
        state.stories.map((story) {
          if (story.id == storyId && !story.isViewed) {
            return story.copyWith(
              isViewed: true,
              viewCount: story.viewCount + 1,
            );
          }
          return story;
        }).toList();

    emit(state.copyWith(stories: updatedStories));
  }

  void resetState() {
    emit(StoryState());
  }

  List<StoryModel> _getMockStories() {
    return [
      StoryModel(
        id: '1',
        userId: 'user1',
        userName: 'Ahmed Ali',
        userEmail: 'ahmed@example.com',
        userImageUrl: 'assets/images/male_runner.png',
        imageUrl: 'assets/images/fitness_partner.png',
        text: 'What a cool day!',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        viewCount: 15,
        likeCount: 8,
        commentCount: 3,
        isLiked: false,
        isViewed: false,
      ),
      StoryModel(
        id: '2',
        userId: 'user2',
        userName: 'Sara Mohammed',
        userEmail: 'sara@example.com',
        userImageUrl: 'assets/images/female_runner.png',
        imageUrl: 'assets/images/friends_step.png',
        text: 'Amazing workout today!',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        viewCount: 23,
        likeCount: 12,
        commentCount: 5,
        isLiked: true,
        isViewed: true,
      ),
    ];
  }

  List<StoryFilterModel> _getMockFilters() {
    return [
      StoryFilterModel(
        id: 'no_filter',
        name: 'No Filter',
        imageUrl: 'assets/images/fitness_partner.png',
        previewUrl: 'assets/images/fitness_partner.png',
        isSelected: true,
      ),
      StoryFilterModel(
        id: 'filter_1',
        name: 'Vintage',
        imageUrl: 'assets/images/friends_step.png',
        previewUrl: 'assets/images/friends_step.png',
        isSelected: false,
      ),
      StoryFilterModel(
        id: 'filter_2',
        name: 'Bright',
        imageUrl: 'assets/images/certified_coaches.png',
        previewUrl: 'assets/images/certified_coaches.png',
        isSelected: false,
      ),
      StoryFilterModel(
        id: 'filter_3',
        name: 'Dark',
        imageUrl: 'assets/images/male_runner.png',
        previewUrl: 'assets/images/male_runner.png',
        isSelected: false,
      ),
    ];
  }
}
