import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

class VerifyOtpUseCase {
  final AuthRepository repo;
  VerifyOtpUseCase({required this.repo});

  Future<ApiResult<String>> call({
    required String email,
    required String token,
  }) {
    return repo.verifyOtp(email: email, token: token);
  }
}
