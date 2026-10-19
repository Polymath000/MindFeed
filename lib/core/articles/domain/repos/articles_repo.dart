import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/author_rating_summary.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';

export 'package:mind_feed/core/articles/domain/entities/author_rating_summary.dart';

abstract class OfflineArticlesRepository {
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article);
  Future<List<DownloadedArticleEntity>> getDownloadedArticles();
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id);
  Future<void> deleteDownloadedArticle(String id);
  Future<void> clearAllDownloadedArticles();
}

abstract class ArticlesRepository {
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  });
  Future<ApiResult<ArticleEntity>> getArticleById(String id);
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  });
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  });
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  });
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  });
  Future<ApiResult<List<CategoryEntity>>> getCategories();
  Future<ApiResult<List<TagEntity>>> getFixedTags();
  Future<ApiResult<void>> starArticle(String articleId, String userId);
  Future<ApiResult<void>> unstarArticle(String articleId, String userId);
  Future<ApiResult<bool>> isArticleStarred(String articleId, String userId);
  Future<ApiResult<void>> saveBookmark(String articleId, String userId);
  Future<ApiResult<void>> removeBookmark(String articleId, String userId);
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId);
  Future<ApiResult<bool>> isArticleSaved(String articleId, String userId);
  Future<ApiResult<ArticleEntity>> saveDraft(Map<String, dynamic> draftData);
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId);
  Future<ApiResult<ArticleEntity>> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  );
  Future<ApiResult<void>> deleteArticle(String articleId);
  Future<void> clearDownloadedArticles();
}

abstract class ArticleEngagementRepository {
  Future<ApiResult<void>> likeArticle(String articleId, String userId);
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId);
  Future<ApiResult<bool>> isArticleLiked(String articleId, String userId);
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  });
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  });
}
