import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class UpdateArticleUseCase {
  final ArticlesRepository repo;

  UpdateArticleUseCase(this.repo);

  Future<ApiResult<ArticleEntity>> call({
    required String articleId,
    required Map<String, dynamic> updates,
    String status = 'draft',
    DateTime? publishedAt,
  }) async {
    if (status == 'published') {
      if (publishedAt == null ||
          DateTime.now().toUtc().difference(publishedAt.toUtc()) >
              const Duration(days: 30)) {
        return const FailureResult(
          ValidationFailure(
            'Published articles can only be edited within 30 days of publication',
          ),
        );
      }
    }
    return repo.updateArticle(articleId, updates);
  }
}
