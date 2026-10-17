import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

class ResendOtpUseCase {
  final AuthRepository repo;
  ResendOtpUseCase({required this.repo});

  Future<ApiResult<void>> call({
    required String email,
    bool isPasswordReset = false,
  }) {
    return repo.resendOtp(
      email: email,
      isPasswordReset: isPasswordReset,
    );
  }
}
