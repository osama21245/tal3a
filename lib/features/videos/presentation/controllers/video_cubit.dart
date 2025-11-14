import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/auth/data/models/user_model.dart';
import 'package:tal3a/features/videos/data/data_source/video_data_source.dart';
import 'package:tal3a/features/videos/data/model/comment_model.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/data/repositories/video_repository_impl.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/network/api_client.dart';
import 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final String userId;
  final VideoRepositoryImpl _videoRepository;
  final List<VideoPlayerController> videoControllers = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  VideoCubit({required this.userId, VideoRepositoryImpl? videoRepository})
    : _videoRepository =
          videoRepository ??
          VideoRepositoryImpl(
            dataSource: VideoDataSourceImpl(apiClient: ApiClient()),
            userId: userId,
          ),
      super(VideoState());

  void loadVideos({bool isLoadMore = false}) async {
    if (state.isLoading || !_hasMore) return;

    emit(state.copyWith(isLoading: true, isError: false));

    try {
      final videosResult = await _videoRepository.getForYouVideos(
        page: _currentPage,
        limit: _limit,
      );

      videosResult.fold(
        (failure) {
          emit(
            state.copyWith(
              isLoading: false,
              isError: true,
              error: failure.message,
            ),
          );
        },
        (videos) async {
          if (videos.length < _limit) _hasMore = false;

          final allVideos = isLoadMore ? [...state.videos, ...videos] : videos;

          if (!isLoadMore) videoControllers.clear();

          for (var video in videos) {
            final controller = VideoPlayerController.network(video.videoUrl)
              ..initialize();
            videoControllers.add(controller);
          }

          _currentPage++;

          emit(
            state.copyWith(isLoading: false, isError: false, videos: allVideos),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, error: e.toString()),
      );
    }
  }

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

  void incrementView(String videoId) async {
    final oldVideos = List.of(state.videos);

    final updatedVideos =
        state.videos.map((v) {
          if (v.id == videoId) {
            return v.copyWith(views: v.views + 1, hasViewed: true);
          }
          return v;
        }).toList();

    emit(state.copyWith(videos: updatedVideos));

    final result = await _videoRepository.viewCountUpdate(videoId: videoId);

    result.fold(
      (failure) {
        emit(state.copyWith(videos: oldVideos));
      },
      (viewsCount) {
        final syncedVideos =
            state.videos.map((v) {
              if (v.id == videoId) {
                return v.copyWith(views: viewsCount);
              }
              return v;
            }).toList();
        emit(state.copyWith(videos: syncedVideos));
      },
    );
  }

  void incrementShare(String videoId) async {
    final oldVideos = List.of(state.videos);
    final updatedVideos =
        state.videos.map((v) {
          if (v.id == videoId) {
            return v.copyWith(shares: v.shares + 1);
          }
          return v;
        }).toList();

    emit(state.copyWith(videos: updatedVideos));

    final result = await _videoRepository.shareCountUpdate(videoId: videoId);

    result.fold(
      (failure) {
        emit(state.copyWith(videos: oldVideos));
      },
      (sharesCount) {
        final syncedVideos =
            state.videos.map((v) {
              if (v.id == videoId) {
                return v.copyWith(shares: sharesCount);
              }
              return v;
            }).toList();
        emit(state.copyWith(videos: syncedVideos));
      },
    );
  }

  Future<void> loadComments({
    required String videoId,
    int page = 1,
    int limit = 20,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(isLoadingComments: true, isError: false));

    final result = await _videoRepository.getComments(
      videoId: videoId,
      page: page,
      limit: limit,
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoadingComments: false,
            isError: true,
            error: failure.message,
          ),
        );
      },
      (comments) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoadingComments: false,
            isError: false,
            comments: comments,
          ),
        );
      },
    );
  }

Future<void> postComment({
  required String videoId,
  required String text,
  required UserModel user,
}) async {
  final tempId = UniqueKey().toString();

  final pending = CommentModel(
    id: tempId,
    videoId: videoId,
    userId: user.id,
    userName: user.fullName,
    userImageUrl: user.profilePic ?? '',
    text: text,
    isPending: true,
    createdAt: DateTime.now(),
  );

  if (isClosed) return;

  emit(state.copyWith(comments: [pending, ...state.comments]));

  final result = await _videoRepository.postComment(
    videoId: videoId,
    text: text,
  );

  if (isClosed) return;

  result.fold(
    (failure) {
      final updatedComments = state.comments
          .map((c) => c.id == tempId ? c.copyWith(isPending: false) : c)
          .toList();

      emit(state.copyWith(
        comments: updatedComments,
        isCommentActionError: true,
        commentActionError: failure.message,
      ));
    },
    (newComment) {
      final updatedComments = state.comments
          .map((c) => c.id == tempId ? newComment : c)
          .toList();

      emit(state.copyWith(
        comments: updatedComments,
        isCommentActionError: false,
        commentActionError: null,
      ));
    },
  );
}


  Future<void> deleteComment({required String commentId}) async {
    final oldComments = List<CommentModel>.from(state.comments);
    final oldPending = List<CommentModel>.from(state.pendingComments);

    final updatedComments =
        oldComments.where((c) => c.id != commentId).toList();

    final updatedPending = oldPending.where((c) => c.id != commentId).toList();

    emit(
      state.copyWith(
        comments: updatedComments,
        pendingComments: updatedPending,
      ),
    );

    final result = await _videoRepository.deleteComment(commentId: commentId);

    result.fold((failure) {
      print("kkkkkkkkkkkkkkk");
      emit(
        state.copyWith(
          comments: oldComments,
          pendingComments: oldPending,
          error: failure.message,
        ),
      );
    }, (_) {});
  }

  Future<void> reportVideo({
    required String videoId,
    required String reason,
    String description = '',
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        isReporting: true,
        reportError: null,
        reportSuccess: false,
      ),
    );

    final result = await _videoRepository.reportVideo(
      videoId: videoId,
      reason: reason,
      description: description,
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(isReporting: false, reportError: failure.message));
      },
      (_) {
        if (isClosed) return;
        emit(state.copyWith(isReporting: false, reportSuccess: true));
      },
    );
  }

  void resetState() {
    emit(VideoState());
  }

  List<VideoModel> _getMockVideos() {
    return [];
  }
}
