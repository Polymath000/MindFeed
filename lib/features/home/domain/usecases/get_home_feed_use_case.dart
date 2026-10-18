import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class GetHomeFeedUseCase {
  final ArticlesRepository repo;

  GetHomeFeedUseCase(this.repo);

  Future<ApiResult<List<ArticleEntity>>> call({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) {
    return repo.getHomeFeed(
      preferredCategoryIds: preferredCategoryIds,
      limit: limit,
      offset: offset,
    );
  }
}
