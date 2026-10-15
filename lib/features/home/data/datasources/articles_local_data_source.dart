import 'package:hive/hive.dart';
import 'package:mind_feed/core/errors/exceptions.dart';
import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';

export 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';

class ArticlesLocalDataSourceImpl implements ArticlesLocalDataSource {
  static const String boxName = 'downloaded_articles';
  final Box<DownloadedArticleEntity>? _box;

  ArticlesLocalDataSourceImpl({Box<DownloadedArticleEntity>? box}) : _box = box;

  Future<Box<DownloadedArticleEntity>> _openBox() async {
    if (_box != null && _box.isOpen) {
      return _box;
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(DownloadedArticleEntityAdapter());
    }
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<DownloadedArticleEntity>(boxName);
    }
    try {
      return await Hive.openBox<DownloadedArticleEntity>(boxName);
    } catch (e) {
      throw CacheException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async {
    try {
      final box = await _openBox();
      await box.put(article.id, article);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async {
    try {
      final box = await _openBox();
      return box.values.toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(errorMessage: e.toString());
    }
  }

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async {
    try {
      final box = await _openBox();
      return box.get(id);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> deleteDownloadedArticle(String id) async {
    try {
      final box = await _openBox();
      await box.delete(id);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> clearAllDownloadedArticles() async {
    try {
      final box = await _openBox();
      await box.clear();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(errorMessage: e.toString());
    }
  }
}
