import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class GetArticlesByTagUseCase {
  final ArticlesRepository repository;

  const GetArticlesByTagUseCase(this.repository);

  Future<ApiResult<List<ArticleEntity>>> call(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) {
    return repository.getArticlesByTag(
      tag,
      limit: limit,
      offset: offset,
    );
  }
}
