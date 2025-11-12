import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import '../../data/models/user_models.dart';

abstract class HomeRepository {
  Future<Either<Failure, UsersResponse>> getAllUsersExceptSelf({
    int? page,
    int? limit,
  });
}
