import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class GetArticleDetailsUseCase {
  final ArticlesRepository repo;

  GetArticleDetailsUseCase(this.repo);

  Future<ApiResult<ArticleEntity>> call(String id) {
    return repo.getArticleById(id);
  }
}
