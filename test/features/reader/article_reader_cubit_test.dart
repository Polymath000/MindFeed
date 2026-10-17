import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/entities/category_entity.dart';
import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/entities/tag_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_state.dart';

class FakeArticlesRepository implements ArticlesRepository, ArticleEngagementRepository {
  bool shouldFailStar = false;
  bool shouldFailUnstar = false;
  bool shouldFailLike = false;
  bool shouldFailRateAuthor = false;
  bool shouldFailBookmark = false;
  bool isStarredValue = false;
  bool isLikedValue = false;
  bool isSavedValue = false;
  int authorUserStars = 0;
  double authorRatingAvg = 0.0;
  int authorRatingCount = 0;
  ArticleEntity? articleDetailsEntity;

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async {
    if (shouldFailStar) {
      return const FailureResult(ServerFailure('Failed to star article'));
    }
    isStarredValue = true;
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async {
    if (shouldFailUnstar) {
      return const FailureResult(ServerFailure('Failed to unstar article'));
    }
    isStarredValue = false;
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> isArticleStarred(
      String articleId, String userId) async {
    return Success(isStarredValue);
  }

  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async {
    if (shouldFailLike || shouldFailStar) {
      return const FailureResult(ServerFailure('Failed to star article'));
    }
    isLikedValue = true;
    isStarredValue = true;
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async {
    if (shouldFailLike || shouldFailUnstar) {
      return const FailureResult(ServerFailure('Failed to unstar article'));
    }
    isLikedValue = false;
    isStarredValue = false;
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> isArticleLiked(
      String articleId, String userId) async {
    return Success(isLikedValue || isStarredValue);
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (shouldFailRateAuthor) {
      return const FailureResult(ServerFailure('Failed to rate author'));
    }
    authorUserStars = stars;
    authorRatingCount = authorRatingCount == 0 ? 1 : authorRatingCount;
    authorRatingAvg = stars.toDouble();
    return Success(
      AuthorRatingSummary(
        authorKey: authorKey,
        userStars: authorUserStars,
        ratingAvg: authorRatingAvg,
        ratingCount: authorRatingCount,
      ),
    );
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    return Success(
      AuthorRatingSummary(
        authorKey: authorKey,
        userStars: authorUserStars,
        ratingAvg: authorRatingAvg,
        ratingCount: authorRatingCount,
      ),
    );
  }

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async {
    if (shouldFailBookmark) {
      return const FailureResult(ServerFailure('Failed to bookmark'));
    }
    isSavedValue = true;
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> removeBookmark(
      String articleId, String userId) async {
    if (shouldFailBookmark) {
      return const FailureResult(ServerFailure('Failed to remove bookmark'));
    }
    isSavedValue = false;
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> isArticleSaved(
      String articleId, String userId) async {
    return Success(isSavedValue);
  }

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async {
    if (articleDetailsEntity != null) {
      return Success(articleDetailsEntity!);
    }
    return const FailureResult(ServerFailure('Not found'));
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async =>
      const Success([]);

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async => const Success([]);

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(
          String userId) async =>
      const Success([]);

  @override
  Future<ApiResult<ArticleEntity>> saveDraft(
          Map<String, dynamic> draftData) async =>
      const FailureResult(ServerFailure('Unimplemented'));

  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async =>
      const FailureResult(ServerFailure('Unimplemented'));

  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
          String articleId, Map<String, dynamic> updates) async =>
      const FailureResult(ServerFailure('Unimplemented'));

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async =>
      const Success(null);

  @override
  Future<void> clearDownloadedArticles() async {}
}

class FakeArticlesLocalDataSource implements ArticlesLocalDataSource {
  final Map<String, DownloadedArticleEntity> storage = {};

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async {
    storage[article.id] = article;
  }

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async =>
      storage.values.toList();

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async =>
      storage[id];

  @override
  Future<void> deleteDownloadedArticle(String id) async {
    storage.remove(id);
  }

  @override
  Future<void> clearAllDownloadedArticles() async {
    storage.clear();
  }
}

EditorialNewsItem createSampleItem({
  String id = 'art_123',
  String title = 'Sample Title',
  String? content,
  int starCount = 5,
  bool isStarred = false,
  bool isSaved = false,
}) {
  return EditorialNewsItem(
    id: id,
    badge: 'TECH',
    badgeColor: const Color(0xFFE57373),
    title: title,
    updated: 'Just now',
    authorName: 'Alex Smith',
    authorRole: 'Senior Writer',
    authorAvatar: '',
    excerpt: 'Sample excerpt text',
    color: const Color(0xFFFBF8F1),
    content: content,
    starCount: starCount,
    isStarred: isStarred,
    isSaved: isSaved,
  );
}

void main() {
  late FakeArticlesRepository fakeRepo;
  late FakeArticlesLocalDataSource fakeLocalDs;
  late ToggleStarUseCase toggleStarUseCase;
  late ToggleArticleLikeUseCase toggleArticleLikeUseCase;
  late RateAuthorUseCase rateAuthorUseCase;
  late GetAuthorRatingUseCase getAuthorRatingUseCase;
  late ToggleBookmarkUseCase toggleBookmarkUseCase;
  late GetArticleDetailsUseCase getArticleDetailsUseCase;
  late DownloadArticleTextUseCase downloadArticleTextUseCase;
  late ArticleReaderCubit cubit;

  setUp(() {
    fakeRepo = FakeArticlesRepository();
    fakeLocalDs = FakeArticlesLocalDataSource();
    toggleStarUseCase = ToggleStarUseCase(fakeRepo);
    toggleArticleLikeUseCase = ToggleArticleLikeUseCase(fakeRepo);
    rateAuthorUseCase = RateAuthorUseCase(fakeRepo);
    getAuthorRatingUseCase = GetAuthorRatingUseCase(fakeRepo);
    toggleBookmarkUseCase = ToggleBookmarkUseCase(fakeRepo);
    getArticleDetailsUseCase = GetArticleDetailsUseCase(fakeRepo);
    downloadArticleTextUseCase = DownloadArticleTextUseCase(fakeLocalDs);

    cubit = ArticleReaderCubit(
      articlesRepository: fakeRepo,
      toggleStarUseCase: toggleStarUseCase,
      toggleArticleLikeUseCase: toggleArticleLikeUseCase,
      rateAuthorUseCase: rateAuthorUseCase,
      getAuthorRatingUseCase: getAuthorRatingUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      getArticleDetailsUseCase: getArticleDetailsUseCase,
      downloadArticleTextUseCase: downloadArticleTextUseCase,
      localDataSource: fakeLocalDs,
      currentUserId: 'test_user_id',
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initArticle with null item emits error state', () async {
    await cubit.initArticle(null);

    expect(cubit.state.status, equals(ArticleReaderStatus.error));
    expect(cubit.state.errorMessage, equals('Article not found'));
  });

  test('initArticle resolves initial state and checks remote like/saved',
      () async {
    fakeRepo.isStarredValue = true;
    fakeRepo.isSavedValue = true;
    final item = createSampleItem(content: 'Full article body');

    await cubit.initArticle(item);

    expect(cubit.state.status, equals(ArticleReaderStatus.ready));
    expect(cubit.state.item?.id, equals(item.id));
    expect(cubit.state.isLiked, isTrue);
    expect(cubit.state.isSaved, isTrue);
    expect(cubit.state.likeCount, equals(5));
  });

  test('initArticle fetches details when content is null', () async {
    fakeRepo.articleDetailsEntity = const ArticleEntity(
      id: 'art_123',
      title: 'Detailed Title',
      slug: 'detailed-title',
      excerpt: 'Detailed excerpt',
      content: '# Full Markdown Body',
      starCount: 12,
    );
    final item = createSampleItem(content: null);

    await cubit.initArticle(item);

    expect(cubit.state.item?.content, equals('# Full Markdown Body'));
    expect(cubit.state.starCount, equals(12));
  });

  test('like toggle performs optimistic update and increments count',
      () async {
    final item = createSampleItem(starCount: 3, isStarred: false);
    await cubit.initArticle(item);

    await cubit.toggleLike();

    expect(cubit.state.isLiked, isTrue);
    expect(cubit.state.likeCount, equals(4));
    expect(fakeRepo.isLikedValue, isTrue);
  });

  test('like toggle reverts on failure and restores count and emits feedback',
      () async {
    final item = createSampleItem(starCount: 7, isStarred: false);
    await cubit.initArticle(item);

    fakeRepo.shouldFailStar = true;
    await cubit.toggleStar();

    expect(cubit.state.isStarred, isFalse);
    expect(cubit.state.starCount, equals(7));
    expect(cubit.state.userFeedback, contains('Failed to star article'));
  });

  test('unlike toggle reverts on failure and restores count', () async {
    final item = createSampleItem(starCount: 10, isStarred: true);
    fakeRepo.isStarredValue = true;
    await cubit.initArticle(item);

    fakeRepo.shouldFailUnstar = true;
    await cubit.toggleStar();

    expect(cubit.state.isStarred, isTrue);
    expect(cubit.state.starCount, equals(10));
    expect(cubit.state.userFeedback, contains('Failed to unstar article'));
  });

  test('rateAuthor updates 1..5 star rating for author and rolls back on error',
      () async {
    final item = createSampleItem(content: 'Body');
    await cubit.initArticle(item);

    await cubit.rateAuthor(5);
    expect(cubit.state.userAuthorStars, equals(5));
    expect(cubit.state.authorRatingAvg, equals(5.0));
    expect(cubit.state.authorRatingCount, equals(1));
    expect(cubit.state.userFeedback, contains('Rated Alex Smith 5/5 stars'));

    fakeRepo.shouldFailRateAuthor = true;
    await cubit.rateAuthor(2);
    expect(cubit.state.userAuthorStars, equals(5));
    expect(cubit.state.userFeedback, contains('Failed to rate author'));
  });

  test('slow scroll toggle, stop, and pace selection update state', () async {
    final item = createSampleItem(content: 'Body');
    await cubit.initArticle(item);

    expect(cubit.state.isSlowScrolling, isFalse);
    expect(cubit.state.scrollPace, equals(1.0));

    cubit.setScrollPace(1.5);
    expect(cubit.state.scrollPace, equals(1.5));

    cubit.toggleSlowScroll();
    expect(cubit.state.isSlowScrolling, isTrue);

    cubit.stopSlowScroll();
    expect(cubit.state.isSlowScrolling, isFalse);
  });

  test('toggleScrollBarRetracted toggles isScrollBarRetracted between false and true', () async {
    expect(cubit.state.isScrollBarRetracted, isFalse);
    cubit.toggleScrollBarRetracted();
    expect(cubit.state.isScrollBarRetracted, isTrue);
    cubit.toggleScrollBarRetracted();
    expect(cubit.state.isScrollBarRetracted, isFalse);
  });

  test('bookmark toggle optimistic update and revert on failure', () async {
    final item = createSampleItem(isSaved: false);
    await cubit.initArticle(item);

    await cubit.toggleBookmark();
    expect(cubit.state.isSaved, isTrue);

    fakeRepo.shouldFailBookmark = true;
    await cubit.toggleBookmark();
    expect(cubit.state.isSaved, isTrue);
    expect(cubit.state.userFeedback, contains('Failed to remove bookmark'));
  });

  test('downloadArticle saves entity text and metadata to local data source',
      () async {
    final item = createSampleItem(content: 'Downloadable body text');
    await cubit.initArticle(item);

    await cubit.downloadArticle();

    expect(cubit.state.isDownloaded, isTrue);
    expect(cubit.state.userFeedback, contains('saved for offline reading'));
    final stored = await fakeLocalDs.getDownloadedArticleById('art_123');
    expect(stored, isNotNull);
    expect(stored?.title, equals('Sample Title'));
    expect(stored?.content, equals('Downloadable body text'));
  });

  test('does not crash when Supabase uninitialized and user is null', () async {
    final unauthedCubit = ArticleReaderCubit(
      articlesRepository: fakeRepo,
      toggleStarUseCase: toggleStarUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: null,
    );
    final item = createSampleItem(starCount: 2);
    await unauthedCubit.initArticle(item);

    await unauthedCubit.toggleStar();
    expect(unauthedCubit.state.isStarred, isFalse);
    expect(unauthedCubit.state.starCount, equals(2));
    expect(unauthedCubit.state.userFeedback, contains('sign in'));

    unauthedCubit.close();
  });
}
