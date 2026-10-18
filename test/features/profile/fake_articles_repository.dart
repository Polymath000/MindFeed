import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class FakeArticlesRepository implements ArticlesRepository {
  List<ArticleEntity> authorArticles = [];
  bool shouldDeleteSucceed = true;
  bool shouldLoadSucceed = true;
  String failureMessage = 'Simulated error';

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (!shouldLoadSucceed) {
      return FailureResult(ServerFailure(failureMessage));
    }
    return Success(List.from(authorArticles));
  }

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async {
    if (!shouldDeleteSucceed) {
      return FailureResult(ServerFailure(failureMessage));
    }
    authorArticles.removeWhere((item) => item.id == articleId);
    return const Success(null);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    return const Success([]);
  }

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async {
    final match = authorArticles.where((a) => a.id == id).firstOrNull;
    if (match != null) return Success(match);
    return FailureResult(ServerFailure('Article not found'));
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async {
    return const Success([]);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    return const Success([]);
  }

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async {
    return const Success([]);
  }

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async {
    return const Success([]);
  }

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> isArticleStarred(String articleId, String userId) async {
    return const Success(false);
  }

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> removeBookmark(String articleId, String userId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async {
    return const Success([]);
  }

  @override
  Future<ApiResult<bool>> isArticleSaved(String articleId, String userId) async {
    return const Success(false);
  }

  @override
  Future<ApiResult<ArticleEntity>> saveDraft(Map<String, dynamic> draftData) async {
    const dummy = ArticleEntity(
      id: 'draft-id',
      title: 'Draft',
      slug: 'draft',
      excerpt: 'Draft excerpt',
    );
    return const Success(dummy);
  }

  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async {
    const dummy = ArticleEntity(
      id: 'published-id',
      title: 'Published',
      slug: 'published',
      excerpt: 'Published excerpt',
      status: 'published',
    );
    return const Success(dummy);
  }

  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    const dummy = ArticleEntity(
      id: 'updated-id',
      title: 'Updated',
      slug: 'updated',
      excerpt: 'Updated excerpt',
    );
    return const Success(dummy);
  }

  @override
  Future<void> clearDownloadedArticles() async {}
}
