import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/editorial_avatar.dart';

class AuthorPersonalInfo extends StatelessWidget {
  final String authorName;
  final String? authorRole;
  final String? authorAvatar;

  const AuthorPersonalInfo({
    super.key,
    this.authorName = 'Wade Warren',
    this.authorRole,
    this.authorAvatar,
  });

  Widget _buildAvatar() {
    final resolved = (authorAvatar != null && authorAvatar!.trim().isNotEmpty)
        ? authorAvatar!.trim()
        : AppConstants.defaultAvatarUrl;
    return EditorialAvatar(
      avatarUrl: resolved,
      size: 96,
      fallbackName: authorName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
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
              child: _buildAvatar(),
            ),
            const SizedBox(height: 14),
            Text(
              authorName,
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
              authorRole ?? 'Investigative Tech & Science Lead • MindFeed',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.greyText,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            EditorialFollowButton(authorName: authorName),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem('86', 'Stories'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: 1,
                  height: 32,
                  color: AppColors.borderDark,
                ),
                _buildStatItem('48.2K', 'Followers'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: 1,
                  height: 32,
                  color: AppColors.borderDark,
                ),
                _buildStatItem('192', 'Following'),
              ],
            ),
          ],
        ),
      ),
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
