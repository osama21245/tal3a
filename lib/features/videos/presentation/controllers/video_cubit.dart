import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/videos/data/data_source/video_data_source.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/data/repositories/video_repository_impl.dart';

import '../../../../core/network/api_client.dart';
import 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final VideoRepositoryImpl _videoRepository;

  VideoCubit({VideoRepositoryImpl? videoRepository})
    : _videoRepository =
          videoRepository ??
          VideoRepositoryImpl(
            dataSource: VideoDataSourceImpl(apiClient: ApiClient()),
          ),
      super(VideoState());
  void loadVideos() async {
    emit(state.copyWith(isLoading: true, isError: false));
    try {
      _videoRepository.getForYouVideos().then((result) {
        result.fold(
          (failure) {
            emit(
              state.copyWith(
                isLoading: false,
                isError: true,
                error: failure.message,
              ),
            );
          },
          (response) {
            if (response.isNotEmpty) {
              emit(
                state.copyWith(
                  isLoading: false,
                  videos: response,
                  isError: false,
                ),
              );
            } else {
              emit(state.copyWith(isLoading: false, isError: true));
            }
          },
        );
      });
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, error: e.toString()),
      );
    }
  }

  // void loadMockVideos() {
  //   emit(state.copyWith(isLoading: true, isError: false));
  //   try {
  //     // TODO: Implement API call to load Videos
  //     final mockVideos = _getMockVideos();
  //     emit(state.copyWith(isLoading: false, videos: mockVideos));
  //   } catch (e) {
  //     emit(
  //       state.copyWith(isLoading: false, isError: true, error: e.toString()),
  //     );
  //   }
  // }

  void toggleLike(String id) async {
    final oldVideos = List.of(state.videos);

    final updatedVideos =
        state.videos.map((v) {
          if (v.id == id) {
            return v.copyWith(
              isLiked: !v.isLiked,
              likes: v.isLiked ? v.likes - 1 : v.likes + 1,
            );
          }
          return v;
        }).toList();

    emit(state.copyWith(videos: updatedVideos));

    final result = await _videoRepository.likeVideo(videoId: id);

    result.fold(
      (failure) {
        emit(state.copyWith(videos: oldVideos));
      },
      (likesCount) {
        final syncedVideos =
            state.videos.map((v) {
              if (v.id == id) {
                return v.copyWith(likes: likesCount);
              }
              return v;
            }).toList();

        emit(state.copyWith(videos: syncedVideos));
      },
    );
  }

  void toggleFollow(String id) {
    final updatedVideos =
        state.videos.map((v) {
          if (v.id == id) {
            return v.copyWith(isFollowed: !v.isFollowed);
          }
          return v;
        }).toList();

    emit(state.copyWith(videos: updatedVideos));
  }

  void resetState() {
    emit(VideoState());
  }

  List<VideoModel> _getMockVideos() {
    return [];
  }
}
