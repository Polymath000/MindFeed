import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ArticleReaderActionBar extends StatelessWidget {
  const ArticleReaderActionBar({
    super.key,
    this.isLiked,
    this.likeCount,
    this.onLikeToggle,
    this.isStarred = false,
    this.starCount = 0,
    this.onStarToggle,
    required this.isSaved,
    required this.isDownloaded,
    required this.onBookmarkToggle,
    required this.onDownload,
    required this.onShare,
  });

  final bool? isLiked;
  final int? likeCount;
  final VoidCallback? onLikeToggle;
  final bool isStarred;
  final int starCount;
  final VoidCallback? onStarToggle;
  final bool isSaved;
  final bool isDownloaded;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final activeLiked = isLiked ?? isStarred;
    final displayCount = (likeCount != null && likeCount! > 0)
        ? likeCount!
        : (likeCount ?? starCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: AppColors.ink,
        borderRadius: AppBorders.control,
        boxShadow: [
          BoxShadow(
            color: AppColors.black45,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LikeButton(
            isActive: activeLiked,
            count: displayCount,
            onTap: onLikeToggle ?? onStarToggle,
          ),
          const SizedBox(width: 4),
          EditorialIconButton(
            icon: isSaved ? AppIcons.bookmark : AppIcons.bookmarkBorderRounded,
            label: 'Save article',
            onPressed: onBookmarkToggle,
          ),
          const SizedBox(width: 4),
          EditorialIconButton(
            icon: isDownloaded ? AppIcons.checkRounded : AppIcons.download,
            label: isDownloaded ? 'Article downloaded' : 'Download article',
            onPressed: onDownload,
          ),
          const SizedBox(width: 4),
          EditorialIconButton(
            icon: AppIcons.iosShareRounded,
            label: 'Share article',
            onPressed: onShare,
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({
    required this.isActive,
    required this.count,
    required this.onTap,
  });

  final bool isActive;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Like article',
      excludeSemantics: true,
      child: Tooltip(
        message: 'Like article',
        child: InkWell(
          key: const Key('article_like_button'),
          onTap: onTap,
          borderRadius: AppBorders.xs,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? AppIcons.thumbUp : AppIcons.thumbUpOutlined,
                  color: isActive ? AppColors.amberDark : AppColors.softCream,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text('$count', style: AppTextStyles.readerActionCount),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
