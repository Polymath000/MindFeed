import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/settings/domain/entities/settings_profile_summary.dart';

class GetSettingsProfileUseCase {
  final ProfileRepository profileRepository;

  const GetSettingsProfileUseCase(this.profileRepository);

  Future<ApiResult<SettingsProfileSummary>> call() async {
    try {
      final session = CurrentUserSession.resolveCurrentUser();
      final local = CurrentUserSession.resolveCachedUserEntity();
      final email = session?.email ?? local?.email ?? '';
      String displayName = session?.displayName ??
          local?.userName ??
          (session?.email?.split('@').first ?? '');
      String? avatarUrl = session?.avatarUrl;
      UserEntity? userEntity = local;

      final userId = session?.id;
      if (userId != null) {
        final profileResult = await profileRepository.getProfile(userId);
        profileResult.when(
          success: (data) {
            final remoteName = data['display_name'] as String?;
            final remoteAvatar = data['avatar_url'] as String?;
            if (remoteName != null && remoteName.isNotEmpty) {
              displayName = remoteName;
            }
            if (remoteAvatar != null && remoteAvatar.isNotEmpty) {
              final resolved =
                  SupabaseStorageService.resolveAvatarUrl(remoteAvatar);
              if (resolved != null && resolved.isNotEmpty) {
                avatarUrl = resolved;
                CurrentUserSession.cacheUserAvatarUrl(avatarUrl!);
              }
            }
          },
          failure: (_) {},
        );

        final favsResult = await profileRepository.getFavoriteCategories(userId);
        favsResult.when(
          success: (list) {
            final cats = list
                .map((m) => (m['name'] ?? m['category_name'] ?? '').toString())
                .where((s) => s.isNotEmpty)
                .toList();
            userEntity = (userEntity ??
                    UserEntity(
                      favoriteCategories: cats,
                      email: email,
                      userName: displayName,
                      token: null,
                    ))
                .copyWith(categories: cats);
          },
          failure: (_) {},
        );
      }

      final resolvedAvatar = SupabaseStorageService.resolveAvatarUrl(avatarUrl);
      if (resolvedAvatar != null && resolvedAvatar.isNotEmpty) {
        avatarUrl = resolvedAvatar;
        CurrentUserSession.cacheUserAvatarUrl(avatarUrl!);
      }

      return Success(
        SettingsProfileSummary(
          displayName: displayName,
          userEmail: email,
          avatarUrl: avatarUrl,
          userEntity: userEntity,
        ),
      );
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
