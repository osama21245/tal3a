import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import 'package:tal3a/core/utils/try_and_catch.dart';
import 'package:tal3a/features/videos/data/data_source/video_data_source.dart';
import 'package:tal3a/features/videos/data/model/comment_model.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/data/model/video_upload_request_model.dart';
import 'package:tal3a/features/videos/data/model/video_upload_response_model.dart';

abstract class VideoRepository {
  Future<Either<Failure, VideoUploadResponseModel>> uploadVideo({
    required VideoUploadRequestModel request,
  });

  Future<Either<Failure, List<VideoModel>>> getForYouVideos();

  Future<Either<Failure, List<VideoModel>>> myPosts({
    required int page,
    required int limit,
    required String status,
  });

  Future<Either<Failure, int>> likeVideo({required String videoId});

  Future<Either<Failure, List<CommentModel>>> getComments({
    required String videoId,
    int page,
    int limit,
  });

  Future<Either<Failure, CommentModel>> postComment({
    required String videoId,
    required String text,
  });

  Future<Either<Failure, void>> deleteComment({required String commentId});

  Future<Either<Failure, int>> viewCountUpdate({required String videoId});
  Future<Either<Failure, int>> shareCountUpdate({required String videoId});
  Future<Either<Failure, void>> reportVideo({
    required String videoId,
    required String reason,
    required String description,
  });
}

class VideoRepositoryImpl implements VideoRepository {
  final String userId;

  final VideoDataSource _dataSource;

  VideoRepositoryImpl({
    required this.userId,
    required VideoDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Either<Failure, VideoUploadResponseModel>> uploadVideo({
    required VideoUploadRequestModel request,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.uploadVideo(request: request);
    });
  }

  // Get ForYou Videos and handling isLike state in the model
  @override
  Future<Either<Failure, List<VideoModel>>> getForYouVideos({
    int page = 1,
    int limit = 10,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final videos = await _dataSource.getForYouVideos(
        page: page,
        limit: limit,
      );

      final updatedVideos =
          videos.map((video) {
            final isLiked = video.likedUsers.contains(userId);
            return video.copyWith(isLiked: isLiked);
          }).toList();

      return updatedVideos;
    });
  }

  @override
  Future<Either<Failure, List<VideoModel>>> myPosts({
    required int page,
    required int limit,
    required String status,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.myPosts(
        page: page,
        limit: limit,
        status: status,
      );
    });
  }

  @override
  Future<Either<Failure, int>> likeVideo({required String videoId}) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.likeVideo(videoId: videoId);
    });
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getComments({
    required String videoId,
    int page = 1,
    int limit = 20,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getComments(
        videoId: videoId,
        page: page,
        limit: limit,
      );
    });
  }

  @override
  Future<Either<Failure, CommentModel>> postComment({
    required String videoId,
    required String text,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.postComment(videoId: videoId, text: text);
    });
  }

  @override
  Future<Either<Failure, void>> deleteComment({
    required String commentId,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.deleteComment(commentId: commentId);
    });
  }

  @override
  Future<Either<Failure, int>> viewCountUpdate({
    required String videoId,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.viewCountUpdate(videoId: videoId);
    });
  }

  @override
  Future<Either<Failure, int>> shareCountUpdate({
    required String videoId,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.shareCountUpdate(videoId: videoId);
    });
  }

  @override
  Future<Either<Failure, void>> reportVideo({
    required String videoId,
    required String reason,
    required String description,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.reportVideo(
        videoId: videoId,
        reason: reason,
        description: description,
      );
    });
  }
}
