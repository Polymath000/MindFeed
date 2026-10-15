import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class GetArticlesByCategoryUseCase {
  final ArticlesRepository repo;

  GetArticlesByCategoryUseCase(this.repo);

  Future<ApiResult<List<ArticleEntity>>> call(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) {
    return repo.getArticlesByCategory(categoryId, limit: limit, offset: offset);
  }
}
