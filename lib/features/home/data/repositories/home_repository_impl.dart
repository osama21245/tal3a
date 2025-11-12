import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import 'package:tal3a/core/utils/try_and_catch.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_data_source.dart';
import '../models/user_models.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl({required HomeDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, UsersResponse>> getAllUsersExceptSelf({
    int? page,
    int? limit,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getAllUsersExceptSelf(page: page, limit: limit);
    });
  }
}
