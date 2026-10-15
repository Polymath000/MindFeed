import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';

abstract class ArticlesLocalDataSource {
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article);
  Future<List<DownloadedArticleEntity>> getDownloadedArticles();
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id);
  Future<void> deleteDownloadedArticle(String id);
  Future<void> clearAllDownloadedArticles();
}
