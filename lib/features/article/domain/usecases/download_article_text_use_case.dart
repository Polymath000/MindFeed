import 'dart:typed_data';

import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';

class DownloadArticleTextUseCase {
  final OfflineArticlesRepository localDataSource;

  DownloadArticleTextUseCase(
    this.localDataSource, {
    Future<Uint8List?> Function(String url)? imageDownloader,
  });

  Future<void> call(DownloadedArticleEntity article) async {
    final resolvedAvatar =
        SupabaseStorageService.resolveAvatarUrl(article.authorAvatar) ??
            article.authorAvatar;

    final entityToSave = DownloadedArticleEntity(
      id: article.id,
      title: article.title,
      excerpt: article.excerpt,
      content: article.content,
      authorName: article.authorName,
      authorRole: article.authorRole,
      authorAvatar: resolvedAvatar,
      categoryId: article.categoryId,
      categorySlug: article.categorySlug,
      tags: article.tags,
      publishedAt: article.publishedAt,
      readingTimeMinutes: article.readingTimeMinutes,
      downloadedAt: article.downloadedAt,
      coverImageUrl: null,
      coverImageBytes: null,
      authorAvatarBytes: null,
    );

    return localDataSource.saveDownloadedArticle(entityToSave);
  }
}

