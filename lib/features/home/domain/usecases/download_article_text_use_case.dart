import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class DownloadArticleTextUseCase {
  final OfflineArticlesRepository localDataSource;

  const DownloadArticleTextUseCase(this.localDataSource);

  Future<void> call(DownloadedArticleEntity article) {
    return localDataSource.saveDownloadedArticle(article);
  }
}
