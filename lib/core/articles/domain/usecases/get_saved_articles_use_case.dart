import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class GetSavedArticlesUseCase {
  final ArticlesRepository repo;

  GetSavedArticlesUseCase(this.repo);

  Future<ApiResult<List<ArticleEntity>>> call(String userId) {
    return repo.getSavedArticles(userId);
  }
}
