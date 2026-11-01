import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';

class GetArchiveCacheSizeUseCase {
  final GetDownloadedArticlesUseCase getDownloadedArticlesUseCase;

  const GetArchiveCacheSizeUseCase(this.getDownloadedArticlesUseCase);

  Future<ApiResult<double>> call() async {
    try {
      final articles = await getDownloadedArticlesUseCase();
      final bytes = articles.fold<int>(
        0,
        (acc, item) =>
            acc +
            item.title.length +
            item.content.length +
            item.excerpt.length +
            (item.coverImageBytes?.length ?? 0) +
            (item.authorAvatarBytes?.length ?? 0),
      );
      final megabytes = bytes / (1024 * 1024);
      return Success(megabytes);
    } catch (e) {
      return FailureResult(CacheFailure(e.toString()));
    }
  }
}
