import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import '../../data/models/auth_models.dart';
import '../../data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignupResponse>> signup(SignupRequest request);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> verifyOtp(String email, String otp);
  Future<Either<Failure, Map<String, dynamic>>> sendVerificationCode({
    required String userId,
    required String type,
  });
  Future<Either<Failure, Map<String, dynamic>>> verifyCode({
    required String userId,
    required String code,
  });
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String phoneNumber,
    required String password,
  });
  Future<Either<Failure, Map<String, dynamic>>> sendForgotCode({
    required String email,
    required String phoneNumber,
  });
  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String email,
    required String phoneNumber,
    required String code,
    required String newPassword,
  });
}
