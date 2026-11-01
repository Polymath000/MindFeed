import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/widgets/editorial_avatar.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';

class ProfileAvatarAndStats extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;
  final String userSubtitle;
  final int articlesCount;
  final int followingCount;
  final bool isUploadingAvatar;
  final VoidCallback? onTapAvatar;

  const ProfileAvatarAndStats({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    required this.userSubtitle,
    required this.articlesCount,
    required this.followingCount,
    this.isUploadingAvatar = false,
    this.onTapAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: isUploadingAvatar ? null : onTapAvatar,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cream, width: 2),
                ),
                child: EditorialAvatar(
                  avatarUrl: avatarUrl,
                  size: 96,
                  fallbackName: displayName,
                ),
              ),
              if (isUploadingAvatar)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blackAlpha115,
                    ),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.cream),
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cream, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 16,
                    color: AppColors.cream,
                  ),
                ),
              ),
            ],
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
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: 1,
              height: 32,
              color: AppColors.borderDark,
            ),
            _buildStatItem('$followingCount', 'Topics'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
