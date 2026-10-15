import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';

class DeleteDownloadedArticleUseCase {
  final ArticlesLocalDataSource localDataSource;

  const DeleteDownloadedArticleUseCase(this.localDataSource);

  Future<void> call(String id) {
    return localDataSource.deleteDownloadedArticle(id);
  }
}
