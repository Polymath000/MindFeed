import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class PersonalInfromation extends StatefulWidget {
  const PersonalInfromation({super.key});

  @override
  State<PersonalInfromation> createState() => _PersonalInfromationState();
}

class _PersonalInfromationState extends State<PersonalInfromation> {
  String _displayName = 'Editorial Reader';
  String _userSubtitle = 'MindFeed Edition';
  String? _avatarUrl;
  int _articlesCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    User? user;
    try {
      user = Supabase.instance.client.auth.currentUser;
    } catch (_) {}

    UserEntity? localUser;
    try {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        localUser = Hive.box<UserEntity>(AppConstants.userKey).get(AppConstants.userKey);
      }
    } catch (_) {}

    final initialName = user?.userMetadata?['display_name'] as String? ??
        localUser?.userName ??
        (user?.email != null ? user!.email!.split('@').first : 'Editorial Reader');
    final initialSubtitle = user?.email ?? localUser?.email ?? 'MindFeed Edition';

    if (mounted) {
      setState(() {
        _displayName = initialName;
        _userSubtitle = initialSubtitle;
        _followingCount = localUser?.favoriteCategories?.length ?? 0;
      });
    }

    if (user != null) {
      if (getIt.isRegistered<ProfileRepository>()) {
        final profileResult = await getIt<ProfileRepository>().getProfile(user.id);
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
                _avatarUrl = remoteAvatar;
              });
            }
          },
          failure: (_) {},
        );

        final favsResult = await getIt<ProfileRepository>().getFavoriteCategories(user.id);
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
        final articlesResult = await getIt<ArticlesRepository>().getArticlesByAuthor(user.id);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cream, width: 2),
                  ),
                  child: ClipOval(
                    child: _avatarUrl != null && _avatarUrl!.isNotEmpty
                        ? Image.network(
                            _avatarUrl!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const CircleAvatar(
                              radius: 48,
                              backgroundColor: AppColors.blush,
                              child: Icon(AppIcons.personAlt, size: 48, color: AppColors.ink),
                            ),
                          )
                        : Image.asset(
                            Assets.assetsImagesWadeAvatar,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const CircleAvatar(
                              radius: 48,
                              backgroundColor: AppColors.blush,
                              child: Icon(AppIcons.personAlt, size: 48, color: AppColors.ink),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.softCream,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatItem('$_articlesCount', 'Articles'),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: 1,
                      height: 32,
                      color: AppColors.borderDark,
                    ),
                    _buildStatItem('$_followingCount', 'Topics'),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: 1,
                      height: 32,
                      color: AppColors.borderDark,
                    ),
                    _buildStatItem('0', 'Followers'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.cream,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.greyText,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
