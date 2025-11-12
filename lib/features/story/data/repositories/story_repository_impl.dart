import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import 'package:tal3a/core/utils/try_and_catch.dart';
import '../data_sources/story_data_source.dart';
import '../models/story_upload_request_model.dart';
import '../models/story_upload_response_model.dart';
import '../models/story_users_response_model.dart';
import '../models/user_stories_response_model.dart';

abstract class StoryRepository {
  Future<Either<Failure, StoryUploadResponseModel>> uploadStory(
    StoryUploadRequestModel request,
  );
  Future<Either<Failure, StoryUsersResponseModel>> getUsersWithStories();
  Future<Either<Failure, UserStoriesResponseModel>> getUserStories(
    String userId,
  );
}

class StoryRepositoryImpl implements StoryRepository {
  final StoryDataSource _dataSource;

  StoryRepositoryImpl({required StoryDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, StoryUploadResponseModel>> uploadStory(
    StoryUploadRequestModel request,
  ) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.uploadStory(request);
    });
  }

  @override
  Future<Either<Failure, StoryUsersResponseModel>> getUsersWithStories() async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getUsersWithStories();
    });
  }

  @override
  Future<Either<Failure, UserStoriesResponseModel>> getUserStories(
    String userId,
  ) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getUserStories(userId);
    });
  }
}
