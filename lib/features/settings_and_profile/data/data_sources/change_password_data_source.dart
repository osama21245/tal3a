import '../../../../core/network/api_client.dart';
import '../models/change_password_models.dart';

abstract class ChangePasswordDataSource {
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequestModel request,
  );
}

class ChangePasswordDataSourceImpl implements ChangePasswordDataSource {
  final ApiClient apiClient;

  ChangePasswordDataSourceImpl({required this.apiClient});

  @override
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequestModel request,
  ) async {
    try {
      final response = await apiClient.postAuthenticated(
        '/api/v1/auth/changePassword',
        body: request.toJson(),
      );

      if (response.isSuccess) {
        return ChangePasswordResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.error ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}
