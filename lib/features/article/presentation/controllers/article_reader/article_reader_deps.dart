import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';

abstract final class ArticleReaderDependencies {
  static DownloadedArticleEntity mapToDownloadedEntity(EditorialNewsItem item) {
    return DownloadedArticleEntity(
      id: item.id,
      title: item.title,
      excerpt: item.excerpt,
      content: (item.content != null && item.content!.isNotEmpty)
          ? item.content!
          : item.excerpt,
      authorName: item.authorName,
      authorRole: item.authorRole,
      authorAvatar: item.authorAvatar,
      categoryId: item.categoryId ?? '',
      categorySlug: item.categorySlug ?? item.badge.toLowerCase(),
      tags: item.tags,
      publishedAt: item.publishedAt ?? DateTime.now(),
      readingTimeMinutes: item.readingTimeMinutes,
      downloadedAt: DateTime.now(),
      coverImageUrl: item.coverImageUrl,
      coverImageBytes: item.coverImageBytes,
      authorAvatarBytes: item.authorAvatarBytes,
    );
  }
}
