import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

class VerifyRecoveryOtpUseCase {
  final AuthRepository repo;

  const VerifyRecoveryOtpUseCase({required this.repo});

  Future<ApiResult<String>> call({
    required String email,
    required String token,
  }) {
    return repo.verifyRecoveryOtp(email: email, token: token);
  }
}
