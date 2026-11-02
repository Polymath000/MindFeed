import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/editorial_avatar.dart';

class AuthorDossierHeader extends StatelessWidget {
  final String displayName;
  final String bio;
  final String avatarUrl;
  final int storiesCount;
  final int followersCount;
  final double ratingAvg;
  final int ratingCount;
  final int userStars;
  final List<String> topics;
  final bool canFollow;
  final bool isFollowing;
  final bool isFollowLoading;
  final bool canRate;
  final VoidCallback? onToggleFollow;
  final ValueChanged<int>? onRate;

  const AuthorDossierHeader({
    super.key,
    required this.displayName,
    this.bio = '',
    this.avatarUrl = '',
    this.storiesCount = 0,
    this.followersCount = 0,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.userStars = 0,
    this.topics = const [],
    this.canFollow = false,
    this.isFollowing = false,
    this.isFollowLoading = false,
    this.canRate = false,
    this.onToggleFollow,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: AppBorders.card,
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIdentityRow(),
          if (topics.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildTopicsSection(),
          ],
          const SizedBox(height: 16),
          _buildMetricsBar(),
          if (canRate) ...[
            const SizedBox(height: 16),
            _buildRatingStrip(),
          ],
        ],
      ),
    );
  }

  Widget _buildIdentityRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditorialAvatar(
          avatarUrl: avatarUrl,
          size: 68,
          fallbackName: displayName,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'COLUMNIST DOSSIER',
                style: AppTextStyles.authorDossierOverline,
              ),
              const SizedBox(height: 4),
              Text(
                displayName,
                style: AppTextStyles.authorDossierName,
              ),
              if (bio.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  bio,
                  style: AppTextStyles.authorDossierBio,
                ),
              ],
            ],
          ),
        ),
        if (canFollow) ...[
          const SizedBox(width: 10),
          EditorialFollowButton(
            authorName: displayName,
            isFollowing: isFollowing,
            isLoading: isFollowLoading,
            onPressed: onToggleFollow,
            darkSurface: true,
          ),
        ],
      ],
    );
  }

  Widget _buildTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WRITES ABOUT',
          style: AppTextStyles.authorDossierSectionLabel,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: topics.map((t) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.inkDark,
                borderRadius: AppBorders.tag,
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Text(
                t,
                style: AppTextStyles.authorDossierTopicPill,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMetricsBar() {
    final ratingDisplay =
        ratingCount > 0 ? '${ratingAvg.toStringAsFixed(1)} ★' : 'New';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inkDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          _buildStatColumn('$storiesCount', 'Stories'),
          _buildDivider(),
          _buildStatColumn('$followersCount', 'Followers'),
          _buildDivider(),
          _buildStatColumn(ratingDisplay, 'Rating'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.authorDossierStatValue,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.authorDossierStatLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.borderDark,
    );
  }

  Widget _buildRatingStrip() {
    final statusText = userStars > 0
        ? 'Your rating: $userStars★ (Tap to change)'
        : 'Rate this author (1–5★)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          statusText,
          style: AppTextStyles.authorDossierSectionLabel,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isFilled = userStars >= starValue;
            return Semantics(
              button: true,
              label: '$starValue star${starValue > 1 ? 's' : ''}',
              child: InkWell(
                key: Key('author_dossier_star_$starValue'),
                onTap: onRate != null ? () => onRate!(starValue) : null,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Icon(
                    isFilled
                        ? AppIcons.starRounded
                        : AppIcons.starOutlineRounded,
                    size: 26,
                    color: isFilled ? AppColors.amber : AppColors.greyText,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
