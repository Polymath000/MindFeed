import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class DeleteDownloadedArticleUseCase {
  final OfflineArticlesRepository localDataSource;

  const DeleteDownloadedArticleUseCase(this.localDataSource);

  Future<void> call(String id) {
    return localDataSource.deleteDownloadedArticle(id);
  }
}
