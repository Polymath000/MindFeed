import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class GetDownloadedArticlesUseCase {
  final OfflineArticlesRepository localDataSource;

  const GetDownloadedArticlesUseCase(this.localDataSource);

  Future<List<DownloadedArticleEntity>> call() {
    return localDataSource.getDownloadedArticles();
  }
}
