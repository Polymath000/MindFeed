import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
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
  });

  final EditorialNewsItem item;
  final VoidCallback onTap;

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
                  Text(
                    item.badge,
                    style: TextStyle(
                      color: item.badgeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
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
          ],
        ),
      ),
    );
  }
}
