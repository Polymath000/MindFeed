import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';

import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class IsArticleLikedUseCase {
  final ArticleEngagementRepository repository;

  const IsArticleLikedUseCase(this.repository);

  Future<ApiResult<bool>> call({
    required String articleId,
    required String userId,
  }) async {
    final trimmedArticleId = articleId.trim();
    final trimmedUserId = userId.trim();
    if (trimmedArticleId.isEmpty || trimmedUserId.isEmpty) {
      return const FailureResult(
        ValidationFailure('Article ID and User ID cannot be empty'),
      );
    }
    return repository.isArticleLiked(trimmedArticleId, trimmedUserId);
  }
}
