import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  const GetUserProfileUseCase(this.repository);

  Future<ApiResult<Map<String, dynamic>>> call(String userId) {
    return repository.getProfile(userId);
  }
}
