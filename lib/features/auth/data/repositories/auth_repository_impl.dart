import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import 'package:tal3a/core/utils/try_and_catch.dart';
import '../data_sources/auth_data_source.dart';
import '../models/auth_models.dart';
import '../models/login_response_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, SignupResponse>> signup(SignupRequest request) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.signup(request);
    });
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.forgotPassword(email);
    });
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otp) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.verifyOtp(email, otp);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendVerificationCode({
    required String userId,
    required String type,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.sendVerificationCode(userId: userId, type: type);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyCode({
    required String userId,
    required String code,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.verifyCode(userId: userId, code: code);
    });
  }

  @override
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.login(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendForgotCode({
    required String email,
    required String phoneNumber,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.sendForgotCode(
        email: email,
        phoneNumber: phoneNumber,
      );
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String email,
    required String phoneNumber,
    required String code,
    required String newPassword,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.resetPassword(
        email: email,
        phoneNumber: phoneNumber,
        code: code,
        newPassword: newPassword,
      );
    });
  }
}
