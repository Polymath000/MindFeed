import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/features/article/domain/entities/article_reader_details.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/article/domain/usecases/check_article_downloaded_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_liked_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_saved_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/load_article_reader_details_use_case.dart';

class MockOfflineArticlesRepo implements OfflineArticlesRepository {
  final Map<String, DownloadedArticleEntity> storage = {};

  @override
  Future<void> clearAllDownloadedArticles() async => storage.clear();

  @override
  Future<void> deleteDownloadedArticle(String id) async => storage.remove(id);

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async =>
      storage[id];

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async =>
      storage.values.toList();

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async =>
      storage[article.id] = article;
}

class MockArticlesRepo implements ArticlesRepository {
  ArticleEntity? articleToReturn;
  Failure? failureToReturn;
  final Set<String> savedArticles = {};

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async {
    if (failureToReturn != null) {
      return FailureResult(failureToReturn!);
    }
    if (articleToReturn != null) {
      return Success(articleToReturn!);
    }
    return const FailureResult(ServerFailure('Article not found'));
  }

  @override
  Future<ApiResult<bool>> isArticleSaved(String articleId, String userId) async {
    return Success(savedArticles.contains('$articleId:$userId'));
  }

  @override
  Future<void> clearDownloadedArticles() async {}
  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async =>
      const Success(null);
  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(String authorId,
          {int limit = 20, int offset = 0}) async =>
      const Success([]);
  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(String categoryId,
          {int limit = 20, int offset = 0}) async =>
      const Success([]);
  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async =>
      const Success([]);
  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async => const Success([]);
  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed(
          {List<String>? preferredCategoryIds,
          int limit = 20,
          int offset = 0}) async =>
      const Success([]);
  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async =>
      const Success([]);
  @override
  Future<ApiResult<bool>> isArticleStarred(
          String articleId, String userId) async =>
      const Success(false);
  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async =>
      FailureResult(const ServerFailure('stub'));
  @override
  Future<ApiResult<void>> removeBookmark(
          String articleId, String userId) async =>
      const Success(null);
  @override
  Future<ApiResult<ArticleEntity>> saveDraft(
          Map<String, dynamic> draftData) async =>
      FailureResult(const ServerFailure('stub'));
  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async =>
      const Success(null);
  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(String query,
          {int limit = 20, int offset = 0}) async =>
      const Success([]);
  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(String tag,
          {int limit = 20, int offset = 0}) async =>
      const Success([]);
  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async =>
      const Success(null);
  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async =>
      const Success(null);
  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
          String articleId, Map<String, dynamic> updates) async =>
      FailureResult(const ServerFailure('stub'));
}

class MockEngagementRepo implements ArticleEngagementRepository {
  final Set<String> likedArticles = {};
  AuthorRatingSummary? ratingSummary;

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    return Success(
      ratingSummary ??
          AuthorRatingSummary(
            authorKey: authorKey,
            userStars: 4,
            ratingAvg: 4.5,
            ratingCount: 10,
          ),
    );
  }

  @override
  Future<ApiResult<bool>> isArticleLiked(String articleId, String userId) async {
    return Success(likedArticles.contains('$articleId:$userId'));
  }

  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async {
    likedArticles.add('$articleId:$userId');
    return const Success(null);
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    return Success(
      AuthorRatingSummary(
        authorKey: authorKey,
        userStars: stars,
        ratingAvg: stars.toDouble(),
        ratingCount: 1,
      ),
    );
  }

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async {
    likedArticles.remove('$articleId:$userId');
    return const Success(null);
  }
}

void main() {
  const testArticle = ArticleEntity(
    id: 'art-123',
    title: 'Test Title',
    slug: 'test-title',
    excerpt: 'Test excerpt',
    authorId: 'author-1',
    authorName: 'Jane Doe',
    likesCount: 5,
    savesCount: 2,
    starCount: 5,
  );

  final testDownloaded = DownloadedArticleEntity(
    id: 'art-123',
    title: 'Test Title',
    excerpt: 'Test excerpt',
    content: 'Full content',
    authorName: 'Jane Doe',
    authorRole: 'Writer',
    authorAvatar: '',
    categoryId: 'tech',
    categorySlug: 'tech',
    tags: const ['tech'],
    publishedAt: DateTime.now(),
    readingTimeMinutes: 3,
    downloadedAt: DateTime.now(),
  );

  group('ArticleReaderDetails entity', () {
    test('creates with expected defaults and props equality', () {
      const details = ArticleReaderDetails(article: testArticle);
      expect(details.article, equals(testArticle));
      expect(details.isLiked, isFalse);
      expect(details.likeCount, equals(0));
      expect(details.isSaved, isFalse);
      expect(details.isDownloaded, isFalse);
      expect(details.authorRating.authorKey, equals(''));

      final updated = details.copyWith(
        isLiked: true,
        likeCount: 6,
        isSaved: true,
        isDownloaded: true,
      );
      expect(updated.isLiked, isTrue);
      expect(updated.likeCount, equals(6));
      expect(updated.isSaved, isTrue);
      expect(updated.isDownloaded, isTrue);
      expect(updated.article, equals(testArticle));
    });
  });

  group('CheckArticleDownloadedUseCase', () {
    test('returns true when article is in offline repo, false otherwise',
        () async {
      final offlineRepo = MockOfflineArticlesRepo();
      final useCase = CheckArticleDownloadedUseCase(offlineRepo);

      expect(await useCase.call('art-123'), isFalse);
      await offlineRepo.saveDownloadedArticle(testDownloaded);
      expect(await useCase.call('art-123'), isTrue);
      expect(await useCase.call('  '), isFalse);
    });
  });

  group('IsArticleLikedUseCase', () {
    test('validates inputs and returns liked status', () async {
      final engRepo = MockEngagementRepo();
      final useCase = IsArticleLikedUseCase(engRepo);

      final emptyRes = await useCase.call(articleId: '', userId: '');
      expect(emptyRes, isA<FailureResult>());

      final res1 = await useCase.call(articleId: 'art-1', userId: 'usr-1');
      expect(res1, isA<Success<bool>>());
      expect((res1 as Success<bool>).data, isFalse);

      await engRepo.likeArticle('art-1', 'usr-1');
      final res2 = await useCase.call(articleId: 'art-1', userId: 'usr-1');
      expect((res2 as Success<bool>).data, isTrue);
    });
  });

  group('IsArticleSavedUseCase', () {
    test('validates inputs and returns saved status', () async {
      final articlesRepo = MockArticlesRepo();
      final useCase = IsArticleSavedUseCase(articlesRepo);

      final emptyRes = await useCase.call(articleId: ' ', userId: 'usr-1');
      expect(emptyRes, isA<FailureResult>());

      final res1 = await useCase.call(articleId: 'art-1', userId: 'usr-1');
      expect((res1 as Success<bool>).data, isFalse);

      articlesRepo.savedArticles.add('art-1:usr-1');
      final res2 = await useCase.call(articleId: 'art-1', userId: 'usr-1');
      expect((res2 as Success<bool>).data, isTrue);
    });
  });

  group('LoadArticleReaderDetailsUseCase', () {
    late MockArticlesRepo articlesRepo;
    late MockOfflineArticlesRepo offlineRepo;
    late MockEngagementRepo engagementRepo;
    late LoadArticleReaderDetailsUseCase useCase;

    setUp(() {
      articlesRepo = MockArticlesRepo();
      offlineRepo = MockOfflineArticlesRepo();
      engagementRepo = MockEngagementRepo();
      useCase = LoadArticleReaderDetailsUseCase(
        articlesRepository: articlesRepo,
        offlineRepository: offlineRepo,
        engagementRepository: engagementRepo,
      );
    });

    test('validates empty articleId', () async {
      final res = await useCase.call(articleId: '   ');
      expect(res, isA<FailureResult>());
    });

    test('returns failure if articlesRepository fails', () async {
      articlesRepo.failureToReturn = const ServerFailure('Database error');
      final res = await useCase.call(articleId: 'art-123');
      expect(res, isA<FailureResult>());
    });

    test('successfully aggregates article reader details with user engagements',
        () async {
      articlesRepo.articleToReturn = testArticle;
      await offlineRepo.saveDownloadedArticle(testDownloaded);
      await engagementRepo.likeArticle('art-123', 'usr-1');
      articlesRepo.savedArticles.add('art-123:usr-1');

      final res = await useCase.call(articleId: 'art-123', userId: 'usr-1');
      expect(res, isA<Success<ArticleReaderDetails>>());

      final details = (res as Success<ArticleReaderDetails>).data;
      expect(details.article, equals(testArticle));
      expect(details.isDownloaded, isTrue);
      expect(details.isLiked, isTrue);
      expect(details.isSaved, isTrue);
      expect(details.likeCount, equals(5));
      expect(details.authorRating.userStars, equals(4));
    });

    test('successfully handles null userId', () async {
      articlesRepo.articleToReturn = testArticle;

      final res = await useCase.call(articleId: 'art-123', userId: null);
      expect(res, isA<Success<ArticleReaderDetails>>());

      final details = (res as Success<ArticleReaderDetails>).data;
      expect(details.isLiked, isFalse);
      expect(details.isSaved, isFalse);
      expect(details.isDownloaded, isFalse);
    });
  });
}
