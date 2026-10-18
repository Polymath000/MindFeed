import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class SaveDraftUseCase {
  final ArticlesRepository repo;

  SaveDraftUseCase(this.repo);

  Future<ApiResult<ArticleEntity>> call(Map<String, dynamic> draftData) {
    return repo.saveDraft(draftData);
  }
}
