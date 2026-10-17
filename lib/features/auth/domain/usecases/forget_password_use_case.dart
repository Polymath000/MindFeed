import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

class ForgetPasswordUseCase {
  final AuthRepository repo;

  const ForgetPasswordUseCase({required this.repo});

  Future<ApiResult<void>> call({required String email}) {
    return repo.forgetPassword(email);
  }
}
