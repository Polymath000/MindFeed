import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class SearchArticlesUseCase {
  final ArticlesRepository repo;

  SearchArticlesUseCase(this.repo);

  Future<ApiResult<List<ArticleEntity>>> call(
    String query, {
    int limit = 20,
    int offset = 0,
  }) {
    return repo.searchArticles(query, limit: limit, offset: offset);
  }
}
