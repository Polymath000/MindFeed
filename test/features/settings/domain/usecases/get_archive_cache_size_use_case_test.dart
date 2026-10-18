import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';

class _FakeOfflineArticlesRepository implements OfflineArticlesRepository {
  List<DownloadedArticleEntity> articles = [];
  bool shouldThrow = false;

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async {
    if (shouldThrow) {
      throw Exception('disk failure');
    }
    return articles;
  }

  @override
  Future<void> clearAllDownloadedArticles() async {
    articles.clear();
  }

  @override
  Future<void> deleteDownloadedArticle(String id) async {
    articles.removeWhere((a) => a.id == id);
  }

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async => null;

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async {
    articles.add(article);
  }
}

void main() {
  late _FakeOfflineArticlesRepository fakeRepo;
  late GetDownloadedArticlesUseCase getDownloadedUseCase;
  late GetArchiveCacheSizeUseCase cacheSizeUseCase;

  setUp(() {
    fakeRepo = _FakeOfflineArticlesRepository();
    getDownloadedUseCase = GetDownloadedArticlesUseCase(fakeRepo);
    cacheSizeUseCase = GetArchiveCacheSizeUseCase(getDownloadedUseCase);
  });

  group('GetArchiveCacheSizeUseCase', () {
    test('returns 0.0 MB when no articles are downloaded', () async {
      final result = await cacheSizeUseCase();
      expect(result, isA<Success<double>>());
      result.when(
        success: (sizeMb) => expect(sizeMb, equals(0.0)),
        failure: (f) => fail('Expected success, got $f'),
      );
    });

    test('calculates correct megabytes for downloaded articles', () async {
      final article = DownloadedArticleEntity(
        id: '1',
        title: 'A' * 1024,
        excerpt: 'B' * 1024,
        content: 'C' * (1024 * 1024 - 2048),
        authorName: 'Reporter',
        authorRole: 'Journalist',
        authorAvatar: '',
        categoryId: 'cat_tech',
        categorySlug: 'tech',
        tags: const ['Tech'],
        publishedAt: DateTime(2026, 1, 1),
        readingTimeMinutes: 3,
        downloadedAt: DateTime(2026, 1, 2),
      );
      fakeRepo.articles.add(article);

      final result = await cacheSizeUseCase();
      expect(result, isA<Success<double>>());
      result.when(
        success: (sizeMb) => expect(sizeMb, closeTo(1.0, 0.001)),
        failure: (f) => fail('Expected success, got $f'),
      );
    });

    test('returns FailureResult when repository throws exception', () async {
      fakeRepo.shouldThrow = true;
      final result = await cacheSizeUseCase();
      expect(result, isA<FailureResult<double>>());
    });
  });
}
