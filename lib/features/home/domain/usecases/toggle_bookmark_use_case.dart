import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class ToggleBookmarkUseCase {
  final ArticlesRepository repo;

  ToggleBookmarkUseCase(this.repo);

  Future<ApiResult<bool>> call({
    required String articleId,
    required String userId,
    required bool isCurrentlySaved,
  }) async {
    if (isCurrentlySaved) {
      final result = await repo.removeBookmark(articleId, userId);
      return result.when(
        success: (_) => const Success(false),
        failure: (failure) => FailureResult(failure),
      );
    } else {
      final result = await repo.saveBookmark(articleId, userId);
      return result.when(
        success: (_) => const Success(true),
        failure: (failure) => FailureResult(failure),
      );
    }
  }
}
