import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/collections/domain/usecases/delete_downloaded_article_use_case.dart';
import 'package:mind_feed/features/collections/presentation/controllers/collections_cubit.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_cubit.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_user_feed_topics_use_case.dart';
import 'package:mind_feed/features/home/presentation/controllers/home_feed/home_feed_cubit.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/views/main_view.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/views/profile_view.dart';
import 'package:mind_feed/features/search/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/search_articles_use_case.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';

class _FakeArticlesRepo extends Fake
    implements ArticlesRepository, ArticleEngagementRepository {
  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async =>
      const Success([]);

  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async =>
      const Success(null);

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
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([]);

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async =>
      const Success([]);

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async =>
      const Success([]);
}

class _FakeProfileRepo extends Fake implements ProfileRepository {
  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) async =>
      const Success({});

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(
    String userId,
  ) async =>
      const Success([]);
}

class _FakeOfflineArticlesRepo extends Fake
    implements OfflineArticlesRepository {
  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async => [];

  @override
  Future<void> deleteDownloadedArticle(String id) async {}
}

void main() {
  setUp(() async {
    await getIt.reset();
    final repo = _FakeArticlesRepo();
    final profileRepo = _FakeProfileRepo();
    final offlineRepo = _FakeOfflineArticlesRepo();

    getIt.registerLazySingleton<GetHomeFeedUseCase>(
      () => GetHomeFeedUseCase(repo),
    );
    getIt.registerFactory<HomeFeedCubit>(
      () => HomeFeedCubit(
        getHomeFeedUseCase: GetHomeFeedUseCase(repo),
        getUserFeedTopicsUseCase: GetUserFeedTopicsUseCase(
          profileRepository: profileRepo,
        ),
        getSavedArticlesUseCase: GetSavedArticlesUseCase(repo),
        toggleBookmarkUseCase: ToggleBookmarkUseCase(repo),
        toggleStarUseCase: ToggleStarUseCase(repo),
        toggleArticleLikeUseCase: ToggleArticleLikeUseCase(repo),
      ),
    );
    getIt.registerFactory<CollectionsCubit>(
      () => CollectionsCubit(
        getSavedArticlesUseCase: GetSavedArticlesUseCase(repo),
        toggleBookmarkUseCase: ToggleBookmarkUseCase(repo),
      ),
    );
    getIt.registerLazySingleton<GetDownloadedArticlesUseCase>(
      () => GetDownloadedArticlesUseCase(offlineRepo),
    );
    getIt.registerLazySingleton<DeleteDownloadedArticleUseCase>(
      () => DeleteDownloadedArticleUseCase(offlineRepo),
    );
    getIt.registerFactory<DownloadsCubit>(
      () => DownloadsCubit(
        getDownloadedArticlesUseCase: getIt<GetDownloadedArticlesUseCase>(),
        deleteDownloadedArticleUseCase: getIt<DeleteDownloadedArticleUseCase>(),
      ),
    );
    getIt.registerFactory<ProfileArticlesCubit>(
      () => ProfileArticlesCubit(
        getArticlesByAuthorUseCase: GetArticlesByAuthorUseCase(repo),
        deleteArticleUseCase: DeleteArticleUseCase(repo),
      ),
    );
    getIt.registerFactory<SearchCubit>(
      () => SearchCubit(
        searchArticlesUseCase: SearchArticlesUseCase(repo),
        getArticlesByCategoryUseCase: GetArticlesByCategoryUseCase(repo),
        getCategoriesUseCase: GetCategoriesUseCase(repo),
        getFixedTagsUseCase: GetFixedTagsUseCase(repo),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildTestableWidget() {
    return const MaterialApp(
      home: MainView(),
    );
  }

  testWidgets(
      'MainView lazily mounts tabs and navigates directly back to Home on back press',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    // 1. Initial tab is HomeView; others are not yet mounted
    expect(find.byType(HomeView), findsOneWidget);
    expect(find.byType(SearchView), findsNothing);
    expect(find.byType(ArticlesSaved), findsNothing);
    expect(find.byType(DownloadedArticlesView), findsNothing);
    expect(find.byType(ProfileView), findsNothing);

    // 2. Tap Search tab
    await tester.tap(find.byTooltip('Search'));
    await tester.pump();
    expect(find.byType(SearchView), findsOneWidget);

    // 3. Tap Saved tab
    await tester.tap(find.byTooltip('Saved news'));
    await tester.pump();
    expect(find.byType(ArticlesSaved), findsOneWidget);

    // 4. Tap Downloads tab
    await tester.tap(find.byTooltip('Downloads'));
    await tester.pump();
    expect(find.byType(DownloadedArticlesView), findsOneWidget);

    // 5. Tap Profile tab
    await tester.tap(find.byTooltip('Profile'));
    await tester.pump();
    expect(find.byType(ProfileView), findsOneWidget);

    // 6. System back: returns directly to HomeView (not the last visited tab)
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(HomeView), findsOneWidget);
  });

  testWidgets(
      'MainView back press from Search and Saved also returns directly to Home',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    // From Search -> Home
    await tester.tap(find.byTooltip('Search'));
    await tester.pump();
    expect(find.byType(SearchView), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(HomeView), findsOneWidget);

    // From Saved -> Home
    await tester.tap(find.byTooltip('Saved news'));
    await tester.pump();
    expect(find.byType(ArticlesSaved), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(HomeView), findsOneWidget);

    // From Downloads -> Home
    await tester.tap(find.byTooltip('Downloads'));
    await tester.pump();
    expect(find.byType(DownloadedArticlesView), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(HomeView), findsOneWidget);
  });

  testWidgets('MainView tapping same active tab handles refresh', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    // Tap Saved news tab
    await tester.tap(find.byTooltip('Saved news'));
    await tester.pump();
    expect(find.byType(ArticlesSaved), findsOneWidget);

    // Tap Saved news tab again while active (triggers refresh)
    await tester.tap(find.byTooltip('Saved news'));
    await tester.pump();
    expect(find.byType(ArticlesSaved), findsOneWidget);

    // Tap Downloads tab
    await tester.tap(find.byTooltip('Downloads'));
    await tester.pump();
    expect(find.byType(DownloadedArticlesView), findsOneWidget);

    // Tap Downloads tab again while active (triggers refresh)
    await tester.tap(find.byTooltip('Downloads'));
    await tester.pump();
    expect(find.byType(DownloadedArticlesView), findsOneWidget);

    // Pressing back goes directly to HomeView
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(HomeView), findsOneWidget);
  });
}
