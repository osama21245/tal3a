import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../models/user_models.dart';

abstract class HomeDataSource {
  Future<UsersResponse> getAllUsersExceptSelf({int? page, int? limit});
}

class HomeDataSourceImpl implements HomeDataSource {
  final ApiClient _apiClient;

  HomeDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<UsersResponse> getAllUsersExceptSelf({int? page, int? limit}) async {
    final queryParams = <String, String>{};

    if (page != null) {
      queryParams['page'] = page.toString();
    }

    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    final response = await _apiClient.getAuthenticated(
      ApiConstants.getAllUsersExceptSelfEndpoint,
      queryParams: queryParams,
    );

    if (response.isSuccess) {
      return UsersResponse.fromJson(response.data);
    } else {
      throw ServerException(
        message: 'Failed to fetch users: ${response.error}',
      );
    }
  }
}
