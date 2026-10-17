import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/entities/category_entity.dart';
import 'package:mind_feed/features/home/domain/entities/tag_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/views/main_view.dart';
import 'package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart';
import 'package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/features/settings/presentation/views/settings_view.dart';

Widget editorialHarness(Widget child) =>
    MaterialApp(theme: ThemeData.light(), home: child);

class _FakeArticlesRepository implements ArticlesRepository {
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

  setUp(() {
    final repo = _FakeArticlesRepository(sampleArticle);
    if (getIt.isRegistered<GetHomeFeedUseCase>()) {
      getIt.unregister<GetHomeFeedUseCase>();
    }
    getIt.registerLazySingleton<GetHomeFeedUseCase>(
      () => GetHomeFeedUseCase(repo),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<GetHomeFeedUseCase>()) {
      getIt.unregister<GetHomeFeedUseCase>();
    }
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
      expect(find.byTooltip('Open profile'), findsOneWidget);
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

  testWidgets('floating editorial navigation exposes three destinations', (
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

    expect(mastheadFinder, findsOneWidget);
    expect(homeNavFinder, findsOneWidget);

    final mastheadPos = tester.getTopLeft(mastheadFinder);
    final navPos = tester.getTopLeft(homeNavFinder);

    expect(mastheadPos.dy, lessThan(200));
    expect(navPos.dy, greaterThan(700));

    final homeRect = tester.getRect(find.byType(HomeView));
    expect(homeRect.bottom, equals(844.0));
    expect(homeRect.bottom, greaterThan(navPos.dy));
  });

  testWidgets('settings renders paper aesthetic sections and preferences', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<ThemeModeCubit>(
        create: (_) => ThemeModeCubit(),
        child: editorialHarness(const SettingsView()),
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
