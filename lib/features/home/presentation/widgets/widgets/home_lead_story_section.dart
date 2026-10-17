import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(24)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.badge,
                        style: TextStyle(
                          color: item.badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item.readingTimeMinutes} min read',
                        style: const TextStyle(
                          color: AppColors.greyText,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title.replaceAll('\n', ' '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.softCream,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (onToggleSave != null)
              StatefulBuilder(
                builder: (context, setTileState) => IconButton(
                  icon: Icon(
                    item.isSaved ? AppIcons.bookmark : AppIcons.bookmarkBorderRounded,
                    color: item.isSaved ? AppColors.yellowHighlight : AppColors.softCream.withAlpha(180),
                    size: 20,
                  ),
                  tooltip: item.isSaved ? 'Remove bookmark' : 'Bookmark story',
                  onPressed: () {
                    onToggleSave!();
                    setTileState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
