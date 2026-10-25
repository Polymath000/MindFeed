import 'package:flutter/material.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';

class DownloadedArticleCardTile extends StatelessWidget {
  final DownloadedArticleEntity article;
  final bool isDark;
  final VoidCallback onDelete;

  const DownloadedArticleCardTile({
    super.key,
    required this.article,
    required this.isDark,
    required this.onDelete,
  });

  String _formatDate(DateTime dt) {
    final year = dt.year;
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Widget? _buildCoverBanner() {
    if (article.coverImageBytes != null &&
        article.coverImageBytes!.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.memory(
          article.coverImageBytes!,
          height: 120,
          width: double.infinity,
          cacheWidth: 1080,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      );
    }

    final coverUrl =
        SupabaseStorageService.resolveArticleMediaUrl(article.coverImageUrl) ??
            article.coverImageUrl;
    if (coverUrl != null && coverUrl.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          coverUrl.trim(),
          height: 120,
          width: double.infinity,
          cacheWidth: 1080,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final coverBanner = _buildCoverBanner();

    return Dismissible(
      key: Key('download_${article.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.redAccent.shade700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.delete, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkTile : AppColors.lightGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : Colors.black12,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 30 : 15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.article,
                arguments: article.toEditorialNewsItem(),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (coverBanner != null) coverBanner,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.ink,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              article.categorySlug.isNotEmpty
                                  ? article.categorySlug.toUpperCase()
                                  : 'OFFLINE',
                              style: const TextStyle(
                                color: AppColors.softCream,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              AppIcons.delete,
                              size: 20,
                              color: AppColors.mutedInk,
                            ),
                            tooltip: 'Delete downloaded article',
                            onPressed: onDelete,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: isDark ? AppColors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '${article.readingTimeMinutes} min read',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.mutedInk,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '•',
                              style: TextStyle(color: AppColors.mutedInk),
                            ),
                          ),
                          Text(
                            'Downloaded ${_formatDate(article.downloadedAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.mutedInk,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (article.authorName.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '•',
                                style: TextStyle(color: AppColors.mutedInk),
                              ),
                            ),
                            Text(
                              article.authorName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedInk,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
