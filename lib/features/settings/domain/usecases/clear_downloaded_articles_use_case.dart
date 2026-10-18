import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class ClearDownloadedArticlesUseCase {
  final OfflineArticlesRepository offlineArticlesRepository;

  const ClearDownloadedArticlesUseCase(this.offlineArticlesRepository);

  Future<ApiResult<void>> call() async {
    try {
      await offlineArticlesRepository.clearAllDownloadedArticles();
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure(e.toString()));
    }
  }
}
