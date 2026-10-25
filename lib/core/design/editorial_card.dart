import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/widgets/editorial_avatar.dart';

class EditorialCard extends StatelessWidget {
  const EditorialCard({
    super.key,
    required this.item,
    this.onOpen,
    this.onLike,
    this.onSave,
    this.onShare,
    this.showActions = true,
    this.backgroundColor,
  });

  final EditorialNewsItem item;
  final VoidCallback? onOpen;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final bool showActions;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;
    return Semantics(
      button: !isSkeleton,
      label: 'Read ${item.title.replaceAll('\n', ' ')}',
      child: InkWell(
        onTap: isSkeleton ? null : onOpen,
        borderRadius: AppBorders.card,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          decoration: BoxDecoration(
            color: backgroundColor ?? item.color,
            borderRadius: AppBorders.card,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: item.badgeColor, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.isLive) ...[
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          ),
                        ],
                        Text(item.badge, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                    child: Text('${item.readingTimeMinutes} MIN READ', style: const TextStyle(color: AppColors.ink, fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(fontSize: 26, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: -0.9, color: AppColors.ink),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(item.updated, style: const TextStyle(color: AppColors.mutedInk, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Row(
                children: [
                  EditorialAvatar(
                    avatarUrl: item.authorAvatar,
                    avatarBytes: item.authorAvatarBytes,
                    size: 38,
                    fallbackName: item.authorName,
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.authorRole, style: const TextStyle(fontSize: 10.5, color: AppColors.mutedInk, fontWeight: FontWeight.w500)),
                      Text(item.authorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    ],
                  ),
                ),
                EditorialFollowButton(authorName: item.authorName),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                item.excerpt,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14.5, height: 1.48, color: AppColors.ink, fontWeight: FontWeight.w400),
              ),
            ),
            if (showActions) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  EditorialIconButton(
                    icon: item.isLiked ? AppIcons.thumbUp : AppIcons.thumbUpOutlined,
                    label: 'Like article',
                    light: true,
                    onPressed: onLike,
                  ),
                  if (item.likesCount > 0) ...[
                    const SizedBox(width: 2),
                    Text('${item.likesCount}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.mutedInk)),
                  ],
                  const SizedBox(width: 6),
                  EditorialIconButton(
                    icon: item.isSaved ? AppIcons.bookmark : AppIcons.bookmarkBorderRounded,
                    label: 'Save article',
                    light: true,
                    onPressed: onSave,
                  ),
                  const SizedBox(width: 6),
                  EditorialIconButton(
                    icon: AppIcons.iosShareRounded,
                    label: 'Share article',
                    light: true,
                    onPressed: onShare ?? () => showEditorialShareSheet(context, title: item.title),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
  }
}
