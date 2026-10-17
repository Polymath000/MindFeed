import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/design/editorial_card.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class HomeLeadStoryCard extends StatelessWidget {
  const HomeLeadStoryCard({
    super.key,
    required this.item,
    this.onOpen,
    this.onLike,
    this.onSave,
    this.onShare,
  });

  final EditorialNewsItem item;
  final VoidCallback? onOpen;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return EditorialCard(
      item: item,
      onOpen: onOpen,
      onLike: onLike,
      onSave: onSave,
      onShare: onShare,
    );
  }
}

class HomeSecondaryStoryTile extends StatelessWidget {
  const HomeSecondaryStoryTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onToggleSave,
  });

  final EditorialNewsItem item;
  final VoidCallback onTap;
  final VoidCallback? onToggleSave;

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;
    return InkWell(
      onTap: isSkeleton ? null : onTap,
      borderRadius: AppBorders.xxs,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteAlpha18,
          borderRadius: AppBorders.xxs,
          border: Border.all(color: AppColors.whiteAlpha24),
        ),
        child: Row(
          children: [
            Expanded(child: _StoryTileTextContent(item: item)),
            if (onToggleSave != null)
              _StoryBookmarkButton(isSaved: item.isSaved, onPressed: onToggleSave!),
          ],
        ),
      ),
    );
  }
}

class _StoryTileTextContent extends StatelessWidget {
  const _StoryTileTextContent({required this.item});

  final EditorialNewsItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              item.badge,
              style: AppTextStyles.homeStoryBadge(item.badgeColor),
            ),
            Text(
              '${item.readingTimeMinutes} min read',
              style: AppTextStyles.homeStoryReadTime,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          item.title.replaceAll('\n', ' '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.homeStoryTitle,
        ),
      ],
    );
  }
}

class _StoryBookmarkButton extends StatelessWidget {
  const _StoryBookmarkButton({required this.isSaved, required this.onPressed});

  final bool isSaved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSaved ? AppIcons.bookmark : AppIcons.bookmarkBorderRounded,
        color: isSaved ? AppColors.yellowHighlight : AppColors.softCreamAlpha180,
        size: 20,
      ),
      tooltip: isSaved ? 'Remove bookmark' : 'Bookmark story',
      onPressed: onPressed,
    );
  }
}
