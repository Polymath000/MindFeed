import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/home/presentation/cubit/home_feed/home_feed_cubit.dart';
import 'package:mind_feed/features/home/presentation/cubit/home_feed/home_feed_state.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class _FakeArticlesRepo implements ArticlesRepository {
  bool shouldFail = false;
  String failureMessage = 'Network error occurred';
  List<ArticleEntity> articles = [];
  List<ArticleEntity> savedArticles = [];
  bool bookmarkFail = false;
  bool starFail = false;

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    if (shouldFail) {
      return FailureResult(ServerFailure(failureMessage));
    }
    return Success(articles);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async {
    return Success(savedArticles);
  }

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async {
    if (bookmarkFail) return FailureResult(ServerFailure('Save bookmark failed'));
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> removeBookmark(String articleId, String userId) async {
    if (bookmarkFail) return FailureResult(ServerFailure('Remove bookmark failed'));
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async {
    if (starFail) return FailureResult(ServerFailure('Star failed'));
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async {
    if (starFail) return FailureResult(ServerFailure('Unstar failed'));
    return const Success(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProfileRepo implements ProfileRepository {
  List<Map<String, dynamic>> favoriteCategories = [];
  List<Map<String, dynamic>> allCategories = [];

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(
      String userId) async {
    return Success(favoriteCategories);
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getCategories() async {
    return Success(allCategories);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeArticlesRepo fakeArticlesRepo;
  late _FakeProfileRepo fakeProfileRepo;
  late GetHomeFeedUseCase feedUseCase;
  late GetSavedArticlesUseCase savedArticlesUseCase;
  late ToggleBookmarkUseCase toggleBookmarkUseCase;
  late ToggleStarUseCase toggleStarUseCase;

  const sampleArticle1 = ArticleEntity(
    id: 'art_1',
    title: 'Breakthrough in AI Research',
    slug: 'breakthrough-in-ai',
    excerpt: 'New model shows reasoning capabilities.',
    badge: 'TECH',
    tags: ['AI', 'Tech'],
  );

  const sampleArticle2 = ArticleEntity(
    id: 'art_2',
    title: 'New Space Telescope Images',
    slug: 'new-space-telescope',
    excerpt: 'Deep field view reveals early galaxies.',
    badge: 'SCIENCE',
    tags: ['Space', 'Science'],
  );

  setUp(() {
    fakeArticlesRepo = _FakeArticlesRepo();
    fakeProfileRepo = _FakeProfileRepo();
    fakeArticlesRepo.articles = [sampleArticle1, sampleArticle2];
    feedUseCase = GetHomeFeedUseCase(fakeArticlesRepo);
    savedArticlesUseCase = GetSavedArticlesUseCase(fakeArticlesRepo);
    toggleBookmarkUseCase = ToggleBookmarkUseCase(fakeArticlesRepo);
    toggleStarUseCase = ToggleStarUseCase(fakeArticlesRepo);
  });

  test('initial state has default topics and All selected', () {
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
    );
    expect(cubit.state.status, equals(HomeFeedStatus.initial));
    expect(cubit.state.selectedTopic, equals('All'));
    expect(cubit.state.topics, contains('All'));
    expect(cubit.state.allArticles, isEmpty);
    cubit.close();
  });

  test('fetchFeed successfully populates articles and preserves filtering', () async {
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
      currentUserId: 'user_123',
    );

    await cubit.fetchFeed();

    expect(cubit.state.status, equals(HomeFeedStatus.success));
    expect(cubit.state.allArticles.length, equals(2));
    expect(cubit.state.filteredArticles.length, equals(2));

    cubit.selectTopic('Tech');
    expect(cubit.state.selectedTopic, equals('Tech'));
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.title, equals('Breakthrough in AI Research'));

    cubit.selectTopic('Science');
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.title, equals('New Space Telescope Images'));

    cubit.close();
  });

  test('fetchFeed handles offline and network errors gracefully', () async {
    fakeArticlesRepo.shouldFail = true;
    fakeArticlesRepo.failureMessage = 'SocketException: network is offline';

    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
    );

    await cubit.fetchFeed();

    expect(cubit.state.status, equals(HomeFeedStatus.error));
    expect(cubit.state.errorMessage, contains('currently offline'));

    cubit.close();
  });

  test('fetchFeed resolves dynamic favorite categories for logged in user with All first', () async {
    fakeProfileRepo.favoriteCategories = [
      {
        'name': 'Technology',
        'category_name': 'Technology',
      },
      {
        'category_id': 'cat_eco',
        'categories': {'name': 'Ecology'},
      },
    ];

    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
      currentUserId: 'user_456',
    );

    await cubit.fetchFeed();

    expect(cubit.state.status, equals(HomeFeedStatus.success));
    expect(
      cubit.state.topics,
      equals(['All', 'Technology', 'Ecology']),
    );
    expect(cubit.state.topics.first, equals('All'));

    cubit.selectTopic('Technology');
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.id, equals('art_1'));

    cubit.close();
  });

  test('loadFeed marks matching saved articles as saved for logged in user', () async {
    fakeArticlesRepo.savedArticles = [sampleArticle1];

    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
      getSavedArticlesUseCase: savedArticlesUseCase,
      currentUserId: 'user_saved_1',
    );

    await cubit.loadFeed();

    expect(cubit.state.status, equals(HomeFeedStatus.success));
    expect(cubit.state.allArticles.first.id, equals('art_1'));
    expect(cubit.state.allArticles.first.isSaved, isTrue);
    expect(cubit.state.allArticles[1].isSaved, isFalse);

    cubit.close();
  });

  test('saveArticleOnSwipeRight saves article and returns true on success', () async {
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_save_right',
    );

    final item = sampleArticle1.toEditorialNewsItem();
    expect(item.isSaved, isFalse);

    final result = await cubit.saveArticleOnSwipeRight(item);

    expect(result, isTrue);
    expect(item.isSaved, isTrue);

    cubit.close();
  });

  test('saveArticleOnSwipeRight rolls back and returns false on failure or unauthenticated', () async {
    final unauthCubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      userIdResolver: () => null,
    );

    final item1 = sampleArticle1.toEditorialNewsItem();
    final unauthResult = await unauthCubit.saveArticleOnSwipeRight(item1);
    expect(unauthResult, isFalse);
    expect(item1.isSaved, isFalse);
    unauthCubit.close();

    fakeArticlesRepo.bookmarkFail = true;
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_fail',
    );

    final item2 = sampleArticle1.toEditorialNewsItem();
    final failResult = await cubit.saveArticleOnSwipeRight(item2);
    expect(failResult, isFalse);
    expect(item2.isSaved, isFalse);
    cubit.close();
  });

  test('toggleBookmark toggles state optimistically and reverts on error', () async {
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_toggle',
    );

    final item = sampleArticle1.toEditorialNewsItem();
    expect(item.isSaved, isFalse);

    final success = await cubit.toggleBookmark(item);
    expect(success, isTrue);
    expect(item.isSaved, isTrue);

    fakeArticlesRepo.bookmarkFail = true;
    final fail = await cubit.toggleBookmark(item);
    expect(fail, isFalse);
    expect(item.isSaved, isTrue);

    cubit.close();
  });

  test('toggleStar updates starCount and reverts on error', () async {
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      toggleStarUseCase: toggleStarUseCase,
      currentUserId: 'user_star',
    );

    final item = sampleArticle1.toEditorialNewsItem();
    expect(item.isStarred, isFalse);
    expect(item.starCount, equals(0));

    final success = await cubit.toggleStar(item);
    expect(success, isTrue);
    expect(item.isStarred, isTrue);
    expect(item.starCount, equals(1));

    fakeArticlesRepo.starFail = true;
    final fail = await cubit.toggleStar(item);
    expect(fail, isFalse);
    expect(item.isStarred, isTrue);
    expect(item.starCount, equals(1));

    cubit.close();
  });
}
