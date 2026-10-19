import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/collections/presentation/controllers/collections_cubit.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';

class _FakeArticlesRepository implements ArticlesRepository {
  bool shouldFailGetSaved = false;
  String getSavedErrorMessage = 'Failed to load saved';
  bool shouldFailToggleBookmark = false;
  String toggleBookmarkErrorMessage = 'Failed to toggle bookmark';
  List<ArticleEntity> savedArticles = [];
  bool? toggleBookmarkResult;

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async {
    if (shouldFailGetSaved) {
      return FailureResult(ServerFailure(getSavedErrorMessage));
    }
    return Success(savedArticles);
  }

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async {
    if (shouldFailToggleBookmark) {
      return FailureResult(ServerFailure(toggleBookmarkErrorMessage));
    }
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> removeBookmark(String articleId, String userId) async {
    if (shouldFailToggleBookmark) {
      return FailureResult(ServerFailure(toggleBookmarkErrorMessage));
    }
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> isArticleSaved(String articleId, String userId) async {
    return Success(toggleBookmarkResult ?? false);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async =>
      throw UnimplementedError();

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
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async => const Success([]);

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async => const Success([]);

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<bool>> isArticleStarred(
          String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<ArticleEntity>> saveDraft(
          Map<String, dynamic> draftData) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
          String articleId, Map<String, dynamic> updates) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async =>
      const Success(null);

  @override
  Future<void> clearDownloadedArticles() async {}
}

ArticleEntity _createArticle({
  required String id,
  required String title,
  String excerpt = 'Excerpt',
}) {
  return ArticleEntity(
    id: id,
    title: title,
    slug: 'slug-$id',
    excerpt: excerpt,
    badge: 'NEWS',
  );
}

void main() {
  late _FakeArticlesRepository fakeRepo;
  late GetSavedArticlesUseCase getSavedArticlesUseCase;
  late ToggleBookmarkUseCase toggleBookmarkUseCase;

  setUp(() {
    fakeRepo = _FakeArticlesRepository();
    getSavedArticlesUseCase = GetSavedArticlesUseCase(fakeRepo);
    toggleBookmarkUseCase = ToggleBookmarkUseCase(fakeRepo);
  });

  test('initial state is CollectionsInitial', () {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
    );
    expect(cubit.state, isA<CollectionsInitial>());
    cubit.close();
  });

  test('loadSavedStories emits CollectionsError if user is not logged in',
      () async {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      userIdResolver: () => null,
    );

    await cubit.loadSavedStories();

    expect(cubit.state, isA<CollectionsError>());
    expect(
      (cubit.state as CollectionsError).message,
      contains('Please log in'),
    );
    cubit.close();
  });

  test('loadSavedStories emits CollectionsEmpty when no stories are returned',
      () async {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_1',
    );
    fakeRepo.savedArticles = [];

    await cubit.loadSavedStories();

    expect(cubit.state, isA<CollectionsEmpty>());
    expect(cubit.allStories, isEmpty);
    cubit.close();
  });

  test('loadSavedStories emits CollectionsLoaded with stories when found',
      () async {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_1',
    );
    fakeRepo.savedArticles = [
      _createArticle(id: '1', title: 'First Story'),
      _createArticle(id: '2', title: 'Second Story'),
    ];

    await cubit.loadSavedStories();

    expect(cubit.state, isA<CollectionsLoaded>());
    expect(cubit.allStories.length, equals(2));
    expect((cubit.state as CollectionsLoaded).stories.length, equals(2));
    cubit.close();
  });

  test('loadSavedStories maps network failure to offline message', () async {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_1',
    );
    fakeRepo.shouldFailGetSaved = true;
    fakeRepo.getSavedErrorMessage = 'SocketException: Connection refused';

    await cubit.loadSavedStories();

    expect(cubit.state, isA<CollectionsError>());
    expect(
      (cubit.state as CollectionsError).message,
      contains('You are currently offline'),
    );
    cubit.close();
  });

  test('searchStories filters by query or restores all stories on empty query',
      () async {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_1',
    );
    fakeRepo.savedArticles = [
      _createArticle(id: '1', title: 'Flutter Clean Architecture'),
      _createArticle(id: '2', title: 'Rust Systems Programming'),
    ];

    await cubit.loadSavedStories();

    cubit.searchStories('Flutter');
    expect(cubit.state, isA<CollectionsLoaded>());
    expect((cubit.state as CollectionsLoaded).stories.length, equals(1));
    expect((cubit.state as CollectionsLoaded).stories.first.id, equals('1'));

    cubit.searchStories('Nonexistent');
    expect(cubit.state, isA<CollectionsEmpty>());

    cubit.searchStories('');
    expect(cubit.state, isA<CollectionsLoaded>());
    expect((cubit.state as CollectionsLoaded).stories.length, equals(2));

    cubit.close();
  });

  test('deleteArticle removes article on success', () async {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_1',
    );
    fakeRepo.savedArticles = [
      _createArticle(id: '1', title: 'Story to remove'),
    ];
    fakeRepo.toggleBookmarkResult = false; // meaning no longer saved

    await cubit.loadSavedStories();
    expect(cubit.allStories.length, equals(1));

    await cubit.deleteArticle('1');

    expect(cubit.state, isA<CollectionsEmpty>());
    expect(cubit.allStories, isEmpty);

    cubit.close();
  });

  test('deleteArticle handles failure', () async {
    final cubit = CollectionsCubit(
      getSavedArticlesUseCase: getSavedArticlesUseCase,
      toggleBookmarkUseCase: toggleBookmarkUseCase,
      currentUserId: 'user_1',
    );
    fakeRepo.savedArticles = [
      _createArticle(id: '1', title: 'Keep Story'),
    ];
    fakeRepo.shouldFailToggleBookmark = true;
    fakeRepo.toggleBookmarkErrorMessage = 'Failed to unbookmark';

    await cubit.loadSavedStories();
    await cubit.deleteArticle('1');

    expect(cubit.state, isA<CollectionsError>());
    expect((cubit.state as CollectionsError).message, equals('Failed to unbookmark'));

    cubit.close();
  });
}
