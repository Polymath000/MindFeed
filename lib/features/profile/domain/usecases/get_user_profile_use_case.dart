import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  const GetUserProfileUseCase(this.repository);

  Future<ApiResult<Map<String, dynamic>>> call(String userId) async {
    final result = await repository.getProfile(userId);
    return result.when(
      success: (profile) {
        final map = Map<String, dynamic>.from(profile);
        final rawAvatar = map['avatar_url'] as String?;
        final resolved = SupabaseStorageService.resolveAvatarUrl(rawAvatar);
        if (resolved != null && resolved.isNotEmpty) {
          map['avatar_url'] = resolved;
          CurrentUserSession.cacheUserAvatarUrl(resolved);
        } else {
          map.remove('avatar_url');
        }
        return Success(map);
      },
      failure: (failure) => FailureResult(failure),
    );
  }
}
