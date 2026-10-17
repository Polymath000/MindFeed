import 'package:flutter/material.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/presentation/widget/profile_avatar_and_stats.dart';

class PersonalInfromation extends StatefulWidget {
  const PersonalInfromation({super.key});

  @override
  State<PersonalInfromation> createState() => _PersonalInfromationState();
}

class _PersonalInfromationState extends State<PersonalInfromation> {
  String _displayName = '';
  String _userSubtitle = '';
  String? _avatarUrl;
  int _articlesCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final sessionUser = CurrentUserSession.resolveCurrentUser();
    final localUser = CurrentUserSession.resolveCachedUserEntity();

    final initialName = sessionUser?.displayName ??
        localUser?.userName ??
        (sessionUser?.email != null ? sessionUser!.email!.split('@').first : '');
    final initialSubtitle = sessionUser?.email ?? localUser?.email ?? '';

    if (mounted) {
      setState(() {
        _displayName = initialName;
        _userSubtitle = initialSubtitle;
        _avatarUrl = sessionUser?.avatarUrl;
        _followingCount = localUser?.favoriteCategories?.length ?? 0;
      });
    }

    final userId = sessionUser?.id;
    if (userId != null && userId.isNotEmpty) {
      if (getIt.isRegistered<ProfileRepository>()) {
        final profileResult = await getIt<ProfileRepository>().getProfile(userId);
        profileResult.when(
          success: (profile) {
            final remoteName = profile['display_name'] as String?;
            final remoteBio = profile['bio'] as String?;
            final remoteAvatar = profile['avatar_url'] as String?;
            if (mounted) {
              setState(() {
                if (remoteName != null && remoteName.isNotEmpty) {
                  _displayName = remoteName;
                }
                if (remoteBio != null && remoteBio.isNotEmpty) {
                  _userSubtitle = remoteBio;
                }
                if (remoteAvatar != null && remoteAvatar.isNotEmpty) {
                  _avatarUrl = remoteAvatar;
                }
              });
            }
          },
          failure: (_) {},
        );

        final favsResult = await getIt<ProfileRepository>().getFavoriteCategories(userId);
        favsResult.when(
          success: (favs) {
            if (mounted) {
              setState(() {
                _followingCount = favs.length;
              });
            }
          },
          failure: (_) {},
        );
      }

      if (getIt.isRegistered<ArticlesRepository>()) {
        final articlesResult = await getIt<ArticlesRepository>().getArticlesByAuthor(userId);
        articlesResult.when(
          success: (articles) {
            if (mounted) {
              setState(() {
                _articlesCount = articles.length;
              });
            }
          },
          failure: (_) {},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 20),
            child: ProfileAvatarAndStats(
              avatarUrl: _avatarUrl,
              displayName: _displayName,
              userSubtitle: _userSubtitle,
              articlesCount: _articlesCount,
              followingCount: _followingCount,
            ),
          ),
        ),
      ],
    );
  }
}
