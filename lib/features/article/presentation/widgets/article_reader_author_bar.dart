import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ArticleReaderAuthorBar extends StatelessWidget {
  const ArticleReaderAuthorBar({
    super.key,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    this.authorRatingAvg = 0.0,
    this.authorRatingCount = 0,
    this.userAuthorStars = 0,
    this.onRateAuthor,
  });

  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final double authorRatingAvg;
  final int authorRatingCount;
  final int userAuthorStars;
  final ValueChanged<int>? onRateAuthor;

  int get _activeThreshold =>
      userAuthorStars > 0 ? userAuthorStars : authorRatingAvg.round();

  String get _summaryText {
    if (authorRatingCount <= 0) return 'Rate this author (1–5★)';
    final countLabel = authorRatingCount == 1 ? 'rating' : 'ratings';
    final userSuffix = userAuthorStars > 0 ? ' • You: $userAuthorStars★' : '';
    return '${authorRatingAvg.toStringAsFixed(1)} ($authorRatingCount $countLabel)$userSuffix';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIdentityRow(),
        const SizedBox(height: 10),
        _buildRatingRow(),
      ],
    );
  }

  Widget _buildIdentityRow() {
    return Row(
      children: [
        ClipOval(child: _AuthorAvatarImage(avatarUrl: authorAvatar)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(authorRole, style: AppTextStyles.readerAuthorRole),
              Text(authorName, style: AppTextStyles.readerAuthorName),
            ],
          ),
        ),
        EditorialFollowButton(authorName: authorName),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 1; i <= 5; i++)
              _AuthorStarButton(
                starIndex: i,
                isActive: i <= _activeThreshold,
                onTap: () => onRateAuthor?.call(i),
              ),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _summaryText,
            style: AppTextStyles.readerAuthorRatingSummary,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _AuthorStarButton extends StatelessWidget {
  const _AuthorStarButton({
    required this.starIndex,
    required this.isActive,
    required this.onTap,
  });

  final int starIndex;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Rate author $starIndex stars',
      child: InkResponse(
        key: Key('author_star_$starIndex'),
        onTap: onTap,
        radius: 16,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
          child: Icon(
            isActive ? AppIcons.starRounded : AppIcons.starOutlineRounded,
            color: isActive ? AppColors.amberDark : AppColors.mutedInk,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _AuthorAvatarImage extends StatelessWidget {
  const _AuthorAvatarImage({required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl.isEmpty) return _fallback();
    if (avatarUrl.startsWith('http')) {
      return Image.network(
        avatarUrl,
        width: 40,
        height: 40,
        cacheWidth: 120,
        cacheHeight: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }
    return Image.asset(
      avatarUrl,
      width: 40,
      height: 40,
      cacheWidth: 120,
      cacheHeight: 120,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() => const CircleAvatar(
    radius: 20,
    backgroundColor: AppColors.blush,
    child: Icon(AppIcons.personAlt, color: AppColors.ink),
  );
}
