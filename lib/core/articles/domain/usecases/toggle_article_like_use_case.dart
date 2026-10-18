import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class ToggleArticleLikeUseCase {
  final ArticleEngagementRepository repository;

  const ToggleArticleLikeUseCase(this.repository);

  Future<ApiResult<bool>> call({
    required String articleId,
    required String userId,
    required bool isCurrentlyLiked,
  }) async {
    if (articleId.trim().isEmpty || userId.trim().isEmpty) {
      return const FailureResult(
        ServerFailure('Article ID and User ID are required'),
      );
    }
    if (isCurrentlyLiked) {
      final res = await repository.unlikeArticle(articleId, userId);
      return res.when(
        success: (_) => const Success(false),
        failure: (f) => FailureResult(f),
      );
    } else {
      final res = await repository.likeArticle(articleId, userId);
      return res.when(
        success: (_) => const Success(true),
        failure: (f) => FailureResult(f),
      );
    }
  }
}
