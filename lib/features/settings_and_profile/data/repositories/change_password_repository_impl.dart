import '../data_sources/change_password_data_source.dart';
import '../models/change_password_models.dart';

abstract class ChangePasswordRepository {
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequestModel request,
  );
}

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordDataSource dataSource;

  ChangePasswordRepositoryImpl({required this.dataSource});

  @override
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequestModel request,
  ) async {
    try {
      return await dataSource.changePassword(request);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
