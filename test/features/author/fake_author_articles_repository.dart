import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class FakeAuthorArticlesRepository extends Fake implements ArticlesRepository {
  List<ArticleEntity> feedArticles = [];
  bool shouldSucceed = true;
  String errorMessage = 'Failed to load feed';

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    if (!shouldSucceed) {
      return FailureResult(ServerFailure(errorMessage));
    }
    return Success(List.from(feedArticles));
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (!shouldSucceed) {
      return FailureResult(ServerFailure(errorMessage));
    }
    return Success(
      feedArticles.where((a) => a.authorId == authorId).toList(),
    );
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (!shouldSucceed) {
      return FailureResult(ServerFailure(errorMessage));
    }
    return Success(
      feedArticles.where((a) => a.tags.contains(tag)).toList(),
    );
  }
}
