import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class ToggleStarUseCase {
  final ArticlesRepository repo;

  ToggleStarUseCase(this.repo);

  Future<ApiResult<bool>> call({
    required String articleId,
    required String userId,
    required bool isCurrentlyStarred,
  }) async {
    if (isCurrentlyStarred) {
      final result = await repo.unstarArticle(articleId, userId);
      return result.when(
        success: (_) => const Success(false),
        failure: (failure) => FailureResult(failure),
      );
    } else {
      final result = await repo.starArticle(articleId, userId);
      return result.when(
        success: (_) => const Success(true),
        failure: (failure) => FailureResult(failure),
      );
    }
  }
}
