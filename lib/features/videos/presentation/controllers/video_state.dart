import 'package:tal3a/features/videos/data/model/comment_model.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';

class VideoState {
  final bool isLoading;
  final bool isError;
  final String? error;
  final List<VideoModel> videos;
  final List<CommentModel> comments;
  final bool isLoadingComments;
  final List<CommentModel> pendingComments;
  final bool isCommentActionError;
  final String? commentActionError;
  final bool isReporting;
  final bool reportSuccess;
  final String? reportError;

  VideoState({
    this.isLoading = false,
    this.isError = false,
    this.error,
    this.videos = const [],
    this.comments = const [],
    this.pendingComments = const [],
    this.isLoadingComments = false,
    this.isCommentActionError = false,
    this.commentActionError,        
    this.isReporting = false,
    this.reportSuccess = false,
    this.reportError,
  });

  VideoState copyWith({
    bool? isLoading,
    bool? isError,
    String? error,
    List<VideoModel>? videos,
    List<CommentModel>? comments,
    bool? isLoadingComments,
    List<CommentModel>? pendingComments,
    bool? isCommentActionError,
    String? commentActionError,
    bool? isReporting,
    bool? reportSuccess,
    String? reportError,
  }) {
    return VideoState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      error: error ?? this.error,
      videos: videos ?? this.videos,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      pendingComments: pendingComments ?? this.pendingComments,
      isCommentActionError: isCommentActionError ?? this.isCommentActionError,
      commentActionError: commentActionError ?? this.commentActionError,
      isReporting: isReporting ?? this.isReporting,
      reportSuccess: reportSuccess ?? this.reportSuccess,
      reportError: reportError ?? this.reportError,
    );
  }
}
