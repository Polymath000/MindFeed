import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ArticleReaderActionBar extends StatelessWidget {
  const ArticleReaderActionBar({
    super.key,
    required this.isStarred,
    required this.starCount,
    required this.isSaved,
    required this.isDownloaded,
    required this.onStarToggle,
    required this.onBookmarkToggle,
    required this.onDownload,
    required this.onShare,
  });

  final bool isStarred;
  final int starCount;
  final bool isSaved;
  final bool isDownloaded;
  final VoidCallback onStarToggle;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            label: 'Star article',
            excludeSemantics: true,
            child: Tooltip(
              message: 'Star article',
              child: InkWell(
                onTap: onStarToggle,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isStarred
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: isStarred ? Colors.amber : AppColors.softCream,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$starCount',
                        style: const TextStyle(
                          color: AppColors.softCream,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          EditorialIconButton(
            icon: isSaved
                ? AppIcons.bookmark
                : AppIcons.bookmarkBorderRounded,
            label: 'Save article',
            onPressed: onBookmarkToggle,
          ),
          const SizedBox(width: 4),
          EditorialIconButton(
            icon: isDownloaded
                ? AppIcons.checkRounded
                : AppIcons.download,
            label: isDownloaded
                ? 'Article downloaded'
                : 'Download article',
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
