import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
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
          color: isDark ? AppColors.darkTile : AppColors.cream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.creamBorder,
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
            onTap: () async {
              await Navigator.pushNamed(
                context,
                AppRoutes.downloadedArticleReader,
                arguments: article,
              );
              if (context.mounted) {
                context.read<DownloadsCubit?>()?.loadDownloads();
              }
            },
            child: Padding(
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
                          color: isDark ? AppColors.black : AppColors.ink,
                          borderRadius: AppBorders.tag,
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
                        icon: Icon(
                          AppIcons.delete,
                          size: 20,
                          color:
                              isDark ? AppColors.greyText : AppColors.mutedInk,
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
                      color: isDark ? AppColors.softCream : AppColors.ink,
                    ),
                  ),
                  if (article.excerpt.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      article.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color:
                            isDark ? AppColors.greyText : AppColors.mutedInk,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${article.readingTimeMinutes} min read',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDark ? AppColors.greyText : AppColors.mutedInk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '•',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.greyText
                                : AppColors.mutedInk,
                          ),
                        ),
                      ),
                      Text(
                        'Downloaded ${_formatDate(article.downloadedAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDark ? AppColors.greyText : AppColors.mutedInk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (article.authorName.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.greyText
                                  : AppColors.mutedInk,
                            ),
                          ),
                        ),
                        Text(
                          article.authorName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.greyText
                                : AppColors.mutedInk,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
