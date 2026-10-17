import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

class UpdatePasswordUseCase {
  final AuthRepository repo;

  const UpdatePasswordUseCase({required this.repo});

  Future<ApiResult<void>> call({required String newPassword}) {
    return repo.updatePassword(newPassword: newPassword);
  }
}
