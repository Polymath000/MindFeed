import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/editorial_avatar.dart';

class ArticleReaderAuthorBar extends StatelessWidget {
  const ArticleReaderAuthorBar({
    super.key,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    this.authorAvatarBytes,
    this.authorRatingAvg = 0.0,
    this.authorRatingCount = 0,
    this.userAuthorStars = 0,
    this.onRateAuthor,
    this.onAuthorTap,
  });

  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final Uint8List? authorAvatarBytes;
  final double authorRatingAvg;
  final int authorRatingCount;
  final int userAuthorStars;
  final ValueChanged<int>? onRateAuthor;
  final VoidCallback? onAuthorTap;

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
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAuthorTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    EditorialAvatar(
                      avatarUrl: authorAvatar,
                      avatarBytes: authorAvatarBytes,
                      size: 40,
                      fallbackName: authorName,
                    ),
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
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
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
