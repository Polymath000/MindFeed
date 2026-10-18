import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class PublishArticleUseCase {
  final ArticlesRepository repo;

  PublishArticleUseCase(this.repo);

  Future<ApiResult<ArticleEntity>> call({
    required String articleId,
    String? title,
    String? content,
  }) async {
    String resolvedTitle = title?.trim() ?? '';
    String resolvedContent = content?.trim() ?? '';

    if (resolvedTitle.isEmpty || resolvedContent.isEmpty) {
      final articleResult = await repo.getArticleById(articleId);
      final bool failed = articleResult.when(
        success: (article) {
          if (resolvedTitle.isEmpty) resolvedTitle = article.title.trim();
          if (resolvedContent.isEmpty) resolvedContent = (article.content ?? '').trim();
          return false;
        },
        failure: (_) => true,
      );
      if (failed) return articleResult;
    }

    final titleWords = resolvedTitle
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;

    if (titleWords == 0) {
      return const FailureResult(
        ValidationFailure('Article title cannot be empty'),
      );
    }

    if (titleWords > 12) {
      return const FailureResult(
        ValidationFailure('Article title cannot exceed 12 words'),
      );
    }

    final bodyWords = resolvedContent
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;

    if (bodyWords < 300) {
      return const FailureResult(
        ValidationFailure('Article body must be at least 300 words'),
      );
    }

    return repo.publishArticle(articleId);
  }
}
