import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class DeleteArticleUseCase {
  final ArticlesRepository repo;

  DeleteArticleUseCase(this.repo);

  Future<ApiResult<void>> call(String articleId) {
    return repo.deleteArticle(articleId);
  }
}
