import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../models/story_upload_request_model.dart';
import '../models/story_upload_response_model.dart';
import '../models/story_users_response_model.dart';
import '../models/user_stories_response_model.dart';

abstract class StoryDataSource {
  Future<StoryUploadResponseModel> uploadStory(StoryUploadRequestModel request);
  Future<StoryUsersResponseModel> getUsersWithStories();
  Future<UserStoriesResponseModel> getUserStories(String userId);
}

class StoryDataSourceImpl implements StoryDataSource {
  final ApiClient _apiClient;

  StoryDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<StoryUploadResponseModel> uploadStory(
    StoryUploadRequestModel request,
  ) async {
    final response = await _apiClient.uploadMultipartAuthenticated(
      ApiConstants.uploadStoriesEndpoint,
      fields: {'note': request.note},
      files: {'images': request.image},
    );

    if (response.isSuccess) {
      return StoryUploadResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
        message: 'Failed to upload story: ${response.error}',
      );
    }
  }

  @override
  Future<StoryUsersResponseModel> getUsersWithStories() async {
    final response = await _apiClient.getAuthenticated(
      ApiConstants.usersWithStoriesEndpoint,
    );

    if (response.isSuccess) {
      return StoryUsersResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
        message: 'Failed to fetch users with stories: ${response.error}',
      );
    }
  }

  @override
  Future<UserStoriesResponseModel> getUserStories(String userId) async {
    final response = await _apiClient.getAuthenticated(
      '${ApiConstants.getUserStoriesEndpoint}/$userId',
    );

    if (response.isSuccess) {
      return UserStoriesResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
        message: 'Failed to fetch user stories: ${response.error}',
      );
    }
  }
}
