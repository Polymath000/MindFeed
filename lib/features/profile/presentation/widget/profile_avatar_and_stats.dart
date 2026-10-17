import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';

class ProfileAvatarAndStats extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;
  final String userSubtitle;
  final int articlesCount;
  final int followingCount;

  const ProfileAvatarAndStats({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    required this.userSubtitle,
    required this.articlesCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cream, width: 2),
          ),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
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
        if (displayName.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.softCream,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
        if (userSubtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            userSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.greyText,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (ctx) {
                ProfileArticlesCubit? cubit;
                try {
                  cubit = BlocProvider.of<ProfileArticlesCubit>(ctx);
                } catch (_) {}
                if (cubit != null) {
                  return BlocBuilder<ProfileArticlesCubit, ProfileArticlesState>(
                    builder: (ctx, state) {
                      final count = state is ProfileArticlesLoaded
                          ? state.articles.length
                          : (state is ProfileArticlesEmpty ? 0 : articlesCount);
                      return _buildStatItem('$count', 'Articles');
                    },
                  );
                }
                return _buildStatItem('$articlesCount', 'Articles');
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              width: 1,
              height: 32,
              color: AppColors.borderDark,
            ),
            _buildStatItem('$followingCount', 'Topics'),
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
