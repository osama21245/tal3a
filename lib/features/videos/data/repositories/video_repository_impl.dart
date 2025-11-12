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
}

class VideoRepositoryImpl implements VideoRepository {
  final VideoDataSource _dataSource;

  VideoRepositoryImpl({required VideoDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, VideoUploadResponseModel>> uploadVideo({
    required VideoUploadRequestModel request,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.uploadVideo(request: request);
    });
  }

  @override
  Future<Either<Failure, List<VideoModel>>> getForYouVideos() async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getForYouVideos();
    });
  }

  @override
  Future<Either<Failure, List<VideoModel>>> myPosts({
    required int page,
    required int limit,
    required String status,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.myPosts(page: page, limit: limit, status: status);
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
      return await _dataSource.getComments(videoId: videoId, page: page, limit: limit);
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
  Future<Either<Failure, void>> deleteComment({required String commentId}) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.deleteComment(commentId: commentId);
    });
  }
}