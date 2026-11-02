import 'dart:math';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/networking/api_result.dart';

class GetHomeFeedUseCase {
  final ArticlesRepository repo;

  GetHomeFeedUseCase(this.repo);

  Future<ApiResult<List<ArticleEntity>>> call({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
    bool randomize = false,
    Random? random,
  }) async {
    final result = await repo.getHomeFeed(
      preferredCategoryIds: preferredCategoryIds,
      limit: limit,
      offset: offset,
    );
    if (!randomize) return result;

    return result.when(
      success: (articles) {
        if (articles.length <= 1) return Success(articles);
        final shuffled = List<ArticleEntity>.of(articles)..shuffle(random);
        return Success(shuffled);
      },
      failure: FailureResult.new,
    );
  }
}
