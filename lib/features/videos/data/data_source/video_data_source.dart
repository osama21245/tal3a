import 'package:tal3a/core/constants/api_constants.dart';
import 'package:tal3a/features/videos/data/model/comment_model.dart';
import 'package:tal3a/features/videos/data/model/video_upload_request_model.dart';
import 'package:tal3a/features/videos/data/model/video_upload_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../model/video_model.dart';

abstract class VideoDataSource {
  Future<VideoUploadResponseModel> uploadVideo({
    required VideoUploadRequestModel request,
  });
  Future<List<VideoModel>> getForYouVideos();
  Future<List<VideoModel>> myPosts({
    required int page,
    required int limit,
    required String status,
  });
  Future<int> likeVideo({required String videoId});
  Future<List<CommentModel>> getComments({
    required String videoId,
    int page = 1,
    int limit = 20,
  });
  Future<CommentModel> postComment({
    required String videoId,
    required String text,
  });
  Future<void> deleteComment({required String commentId});
}

class VideoDataSourceImpl implements VideoDataSource {
  final ApiClient _apiClient;

  VideoDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  @override
  Future<VideoUploadResponseModel> uploadVideo({
    required VideoUploadRequestModel request,
  }) async {
    final response = await _apiClient.uploadMultipartAuthenticated(
      ApiConstants.uploadVideo,
      fields: {
        'description': request.description,
        'hashtags': request.hashtags.join(','),
      },
      files: {'video': request.videoFile},
    );

    if (response.isSuccess) {
      return VideoUploadResponseModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message:
            'Failed to upload video >>>> ${response.error ?? 'unknown error'}',
      );
    }
  }

  @override
  Future<List<VideoModel>> getForYouVideos() async {
    final response = await _apiClient.getAuthenticated(
      ApiConstants.foryouVideos,
    );

    if (response.isSuccess) {
      final data = response.data['data'] as List;
      return data.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw ServerException(
        message:
            'Failed to fetch For You videos >>>> ${response.error ?? 'Unknown error'}',
      );
    }
  }

  @override
  Future<List<VideoModel>> myPosts({
    required int page,
    required int limit,
    required String status,
  }) async {
    final response = await _apiClient.getAuthenticated(
      ApiConstants.myPosts,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        'status': status,
      },
    );

    if (response.isSuccess) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch >>>> ${response.error}');
    }
  }

  @override
  Future<int> likeVideo({required String videoId}) async {
    final response = await _apiClient.postAuthenticated(
      '${ApiConstants.likeVideo}/$videoId',
    );

    if (response.isSuccess) {
      final likesCount = response.data['likesCount'] as int;
      return likesCount;
    } else {
      throw ServerException(
        message:
            'Failed to like video >>>> ${response.error ?? 'unknown error'}',
      );
    }
  }

  @override
  Future<List<CommentModel>> getComments({
    required String videoId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.getAuthenticated(
      '${ApiConstants.comments}/$videoId',
      queryParams: {'page': page.toString(), 'limit': limit.toString()},
    );

    if (response.isSuccess) {
      final List<dynamic> dataList = response.data['data'] ?? [];
      return dataList.map((e) => CommentModel.fromJson(e)).toList();
    } else {
      throw ServerException(
        message: 'Failed to fetch comments: ${response.error}',
      );
    }
  }

  @override
  Future<CommentModel> postComment({
    required String videoId,
    required String text,
  }) async {
    final response = await _apiClient.postAuthenticated(
      '${ApiConstants.comment}/$videoId',
      body: {'text': text},
    );

    if (response.isSuccess) {
      final data = response.data['data'];
      return CommentModel.fromJson(data);
    } else {
      throw ServerException(
        message: 'Failed to post comment: ${response.error}',
      );
    }
  }

  @override
  Future<void> deleteComment({required String commentId}) async {
    final response = await _apiClient.deleteAuthenticated(
      '${ApiConstants.deleteComment}/$commentId',
    );

    if (response.isSuccess) {
      return;
    } else {
      throw ServerException(
        message: 'Failed to delete comment: ${response.error}',
      );
    }
  }
}
