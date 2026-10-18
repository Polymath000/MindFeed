import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/collections/presentation/controllers/collections_cubit.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/article/domain/usecases/check_article_downloaded_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_user_feed_topics_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_liked_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_saved_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_starred_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/home/presentation/controllers/home_feed/home_feed_cubit.dart';
import 'package:mind_feed/features/article/presentation/views/article_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/views/main_view.dart';
import 'package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart';
import 'package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/views/profile_view.dart';
import 'package:mind_feed/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_settings_profile_use_case.dart';
import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/features/settings/presentation/views/settings_view.dart';

Widget editorialHarness(Widget child) =>
    MaterialApp(theme: ThemeData.light(), home: child);

class _FakeProfileRepoForWidgetTest extends Fake implements ProfileRepository {
  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) async =>
      const Success({});
  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(String userId) async =>
      const Success([]);
}

class _FakeOfflineArticlesRepoForWidgetTest extends Fake implements OfflineArticlesRepository {
  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async => [];
  @override
  Future<void> clearAllDownloadedArticles() async {}
}

class _FakeAuthRepoForWidgetTest extends Fake implements AuthRepository {
  @override
  Future<ApiResult<void>> logout() async => const Success(null);
}

class _FakeArticlesRepository
    implements ArticlesRepository, ArticleEngagementRepository, OfflineArticlesRepository {
  final ArticleEntity sampleArticle;
  _FakeArticlesRepository(this.sampleArticle);

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async =>
      Success([sampleArticle]);

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async =>
      Success(sampleArticle);

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async =>
      Success([sampleArticle]);

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
      Success([sampleArticle]);

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async =>
      const Success([]);

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async =>
      const Success([]);

  @override
  Future<ApiResult<void>> starArticle(
          String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unstarArticle(
          String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<bool>> isArticleStarred(
          String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<void>> saveBookmark(
          String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> removeBookmark(
          String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(
          String userId) async =>
      Success([sampleArticle]);

  @override
  Future<ApiResult<bool>> isArticleSaved(
          String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<ArticleEntity>> saveDraft(
          Map<String, dynamic> draftData) async =>
      Success(sampleArticle);

  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async =>
      Success(sampleArticle);

  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async =>
      Success(sampleArticle);

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async =>
      const Success(null);

  @override
  Future<void> clearDownloadedArticles() async {}

  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<bool>> isArticleLiked(String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async =>
      const FailureResult(ServerFailure('Not found'));

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async =>
      const FailureResult(ServerFailure('Not found'));

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async =>
      null;

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async {}

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async => [];

  @override
  Future<void> deleteDownloadedArticle(String id) async {}

  @override
  Future<void> clearAllDownloadedArticles() async {}
}

void main() {
  const sampleArticle = ArticleEntity(
    id: '1',
    title: 'Demand for Indian tech talent grows globally',
    slug: 'demand-for-indian',
    excerpt: 'Global markets adjust to new sourcing realities.',
    badge: 'TECH',
    tags: ['Tech'],
  );

  setUp(() async {
    await getIt.reset();
    final repo = _FakeArticlesRepository(sampleArticle);
    final profileRepo = _FakeProfileRepoForWidgetTest();
    getIt.registerLazySingleton<GetHomeFeedUseCase>(
      () => GetHomeFeedUseCase(repo),
    );
    getIt.registerFactory<HomeFeedCubit>(
      () => HomeFeedCubit(
        getHomeFeedUseCase: GetHomeFeedUseCase(repo),
        getUserFeedTopicsUseCase: GetUserFeedTopicsUseCase(profileRepository: profileRepo),
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
    getIt.registerFactory<ArticleReaderCubit>(
      () => ArticleReaderCubit(
        getArticleDetailsUseCase: GetArticleDetailsUseCase(repo),
        checkArticleDownloadedUseCase: CheckArticleDownloadedUseCase(repo),
        downloadArticleTextUseCase: DownloadArticleTextUseCase(repo),
        isArticleLikedUseCase: IsArticleLikedUseCase(repo),
        toggleArticleLikeUseCase: ToggleArticleLikeUseCase(repo),
        isArticleSavedUseCase: IsArticleSavedUseCase(repo),
        toggleBookmarkUseCase: ToggleBookmarkUseCase(repo),
        rateAuthorUseCase: RateAuthorUseCase(repo),
        getAuthorRatingUseCase: GetAuthorRatingUseCase(repo),
        toggleStarUseCase: ToggleStarUseCase(repo),
        isArticleStarredUseCase: IsArticleStarredUseCase(repo),
      ),
    );
    getIt.registerFactory<ProfileArticlesCubit>(
      () => ProfileArticlesCubit(
        getArticlesByAuthorUseCase: GetArticlesByAuthorUseCase(repo),
        deleteArticleUseCase: DeleteArticleUseCase(repo),
      ),
    );
    getIt.registerFactory<ProfileInfoCubit>(
      () => ProfileInfoCubit(
        getUserProfileUseCase: GetUserProfileUseCase(profileRepo),
        getFavoriteCategoriesUseCase: GetFavoriteCategoriesUseCase(profileRepo),
        getArticlesByAuthorUseCase: GetArticlesByAuthorUseCase(repo),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'home renders the editorial masthead and lead story on a small phone',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(editorialHarness(const HomeView()));
      await tester.pump();

      expect(find.text('MindFeed'), findsOneWidget);
      expect(find.textContaining('Demand for Indian'), findsOneWidget);
      expect(find.byTooltip('Write article'), findsOneWidget);
    },
  );

  testWidgets(
    'saved and article surfaces retain editorial reading anchors at large text',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(editorialHarness(const ArticlesSaved()));
      expect(find.text('Saved News'), findsOneWidget);
      expect(find.bySemanticsLabel('Search saved news'), findsOneWidget);

      final testArticle = EditorialNewsItem(
        id: '1',
        badge: 'TECH',
        badgeColor: const Color(0xFFE57373),
        title:
            'Demand for Indian generic drugs surges amid global supply shifts',
        updated: 'Updated just now.',
        authorName: 'Dr. Jane Foster',
        authorRole: 'Health & Science Editor',
        authorAvatar: '',
        excerpt:
            'Global markets adjust to new pharmaceutical sourcing realities.',
        color: const Color(0xFFFBF8F1),
        readingTimeMinutes: 5,
      );

      await tester.pumpWidget(editorialHarness(ArticleView(item: testArticle)));
      expect(find.textContaining('Demand for Indian'), findsOneWidget);
      expect(find.bySemanticsLabel('Save article'), findsOneWidget);
    },
  );

  testWidgets('floating editorial navigation exposes navigation and profile destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      editorialHarness(
        MainNavigationBar(selectedIndex: 0, onDestinationSelected: (_) {}),
      ),
    );

    expect(find.bySemanticsLabel('Home'), findsOneWidget);
    expect(find.bySemanticsLabel('Search'), findsOneWidget);
    expect(find.bySemanticsLabel('Saved news'), findsOneWidget);
    expect(find.bySemanticsLabel('Profile'), findsOneWidget);
  });

  testWidgets('main shell renders home at top and navigation at bottom', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(editorialHarness(const MainView()));
    await tester.pump();

    final mastheadFinder = find.text('MindFeed');
    final homeNavFinder = find.bySemanticsLabel('Home');
    final profileNavFinder = find.byTooltip('Profile');

    expect(mastheadFinder, findsOneWidget);
    expect(homeNavFinder, findsOneWidget);
    expect(profileNavFinder, findsOneWidget);

    final mastheadPos = tester.getTopLeft(mastheadFinder);
    final navPos = tester.getTopLeft(homeNavFinder);

    expect(mastheadPos.dy, lessThan(200));
    expect(navPos.dy, greaterThan(700));

    final homeRect = tester.getRect(find.byType(HomeView));
    expect(homeRect.bottom, equals(844.0));
    expect(homeRect.bottom, greaterThan(navPos.dy));

    // Tap Profile tab and verify ProfileView is displayed
    await tester.tap(profileNavFinder);
    await tester.pump();
    expect(find.byType(ProfileView), findsOneWidget);
  });

  testWidgets('settings renders paper aesthetic sections and preferences', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final fakeProfileRepo = _FakeProfileRepoForWidgetTest();
    final fakeOfflineRepo = _FakeOfflineArticlesRepoForWidgetTest();
    final fakeAuthRepo = _FakeAuthRepoForWidgetTest();
    final settingsCubit = SettingsCubit(
      getSettingsProfileUseCase: GetSettingsProfileUseCase(fakeProfileRepo),
      getArchiveCacheSizeUseCase: GetArchiveCacheSizeUseCase(GetDownloadedArticlesUseCase(fakeOfflineRepo)),
      clearDownloadedArticlesUseCase: ClearDownloadedArticlesUseCase(fakeOfflineRepo),
      logoutUseCase: LogoutUseCase(authRepo: fakeAuthRepo),
    )..loadSettings();

    await tester.pumpWidget(
      BlocProvider<ThemeModeCubit>(
        create: (_) => ThemeModeCubit(),
        child: editorialHarness(SettingsView(cubit: settingsCubit)),
      ),
    );

    expect(find.text('Settings & Preferences'), findsOneWidget);
    expect(find.text('Warm Paper'), findsOneWidget);
    expect(find.text('Midnight Ink'), findsOneWidget);
    expect(find.text('Reader'), findsOneWidget);
    expect(find.text('Reading Experience & Surface'), findsOneWidget);
    expect(find.text('Typeface Scale'), findsOneWidget);
    expect(find.text('Serif Literary Immersion'), findsOneWidget);
  });

  testWidgets(
    'onboarding renders editorial theme pages and navigation controls',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(editorialHarness(const OnboardingView()));

      expect(find.text('Discover Stories That Matter'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Read What You Love'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Learn Anytime, Anywhere'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    },
  );
}
