import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class GetArticlesByAuthorUseCase {
  final ArticlesRepository repository;

  const GetArticlesByAuthorUseCase(this.repository);

  Future<ApiResult<List<ArticleEntity>>> call(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) {
    return repository.getArticlesByAuthor(
      authorId,
      limit: limit,
      offset: offset,
    );
  }
}
