abstract class VerificationRepository {
  Future<Map<String, dynamic>> sendVerificationCode({
    required String userId,
    required String type,
  });
}
