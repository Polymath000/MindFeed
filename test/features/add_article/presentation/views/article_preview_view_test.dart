import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/add_article/presentation/views/article_preview_view.dart';
import 'package:mind_feed/features/article/domain/usecases/check_article_downloaded_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_liked_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_saved_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_starred_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/article/presentation/views/article_view.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_action_bar_section.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_slow_scroll_bar_section.dart';

class _FakeArticlesRepo
    implements ArticlesRepository, ArticleEngagementRepository, OfflineArticlesRepository {
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
      Success(AuthorRatingSummary(
        authorKey: authorKey,
        userStars: stars,
        ratingAvg: stars.toDouble(),
        ratingCount: 1,
      ));

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async =>
      const Success(AuthorRatingSummary(
        authorKey: 'ada lovelace',
        userStars: 0,
        ratingAvg: 0.0,
        ratingCount: 0,
      ));

  @override
  Future<ApiResult<bool>> isArticleSaved(String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> removeBookmark(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<bool>> isArticleStarred(String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async =>
      FailureResult(ServerFailure('Not found'));

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

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ArticleReaderCubit _createTestReaderCubit(_FakeArticlesRepo repo) {
  return ArticleReaderCubit(
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
  );
}

void main() {
  late _FakeArticlesRepo repo;

  setUp(() {
    repo = _FakeArticlesRepo();
  });

  final draftItem = EditorialNewsItem(
    id: 'draft-prev-1',
    badge: 'TECH',
    badgeColor: AppColors.ink,
    title: 'Previewing Next Generation AI',
    updated: 'Just now',
    authorName: 'Ada Lovelace',
    authorRole: 'Chief Pioneer',
    authorAvatar: '',
    excerpt: 'Brief teaser excerpt.',
    color: AppColors.cream,
    content: '''
# Main Header

This is a **preview** paragraph describing the article.

- Feature Alpha
- Feature Beta
''',
    status: 'draft',
    tags: const ['AI', 'Tech'],
  );

  Widget buildPreviewHarness({
    required EditorialNewsItem? item,
    ArticleReaderCubit? cubit,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ArticlePreviewView(
          item: item,
          cubit: cubit,
        ),
      ),
    );
  }

  testWidgets('renders fallback empty state when item and cubit are null', (
    tester,
  ) async {
    await tester.pumpWidget(buildPreviewHarness(item: null));

    expect(find.text('Article Not Found'), findsOneWidget);
    expect(find.text('Go Back'), findsOneWidget);
  });

  testWidgets(
    'renders preview using ArticleView layout with title, author, and markdown',
    (tester) async {
      final cubit = _createTestReaderCubit(repo);
      await tester.pumpWidget(
        buildPreviewHarness(item: draftItem, cubit: cubit),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ArticleView), findsOneWidget);
      expect(find.text('Previewing Next Generation AI'), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.text('Main Header'), findsOneWidget);
      expect(find.text('#AI'), findsOneWidget);
      expect(find.text('#Tech'), findsOneWidget);

      await cubit.close();
    },
  );

  testWidgets(
    'renders with just back button and hides bottom action bar, publish buttons, and slow scroll',
    (tester) async {
      final cubit = _createTestReaderCubit(repo);
      await tester.pumpWidget(
        buildPreviewHarness(item: draftItem, cubit: cubit),
      );
      await tester.pumpAndSettle();

      // Only the back button in top bar is displayed
      expect(find.byKey(const Key('preview_back_button')), findsOneWidget);
      expect(find.byIcon(AppIcons.arrowBackRounded), findsOneWidget);

      // Bottom bar and publish buttons are NOT present
      expect(find.text('Draft Preview'), findsNothing);
      expect(find.text('Publish'), findsNothing);
      expect(find.text('Edit'), findsNothing);

      // Cover overlay engagement actions (like, bookmark, download) are hidden
      expect(find.byType(ArticleActionBarSection), findsNothing);

      // Floating slow-scroll button is hidden
      expect(find.byType(ArticleSlowScrollBarSection), findsNothing);

      await cubit.close();
    },
  );

  testWidgets('tapping back button triggers navigation pop', (tester) async {
    final cubit = _createTestReaderCubit(repo);

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/home',
        routes: {
          '/home': (context) => Scaffold(
                body: ElevatedButton(
                  key: const Key('go_to_preview'),
                  onPressed: () => Navigator.pushNamed(context, '/preview'),
                  child: const Text('Go To Preview'),
                ),
              ),
          '/preview': (context) => ArticlePreviewView(item: draftItem, cubit: cubit),
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('go_to_preview')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('preview_back_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('preview_back_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('go_to_preview')), findsOneWidget);
    expect(find.byKey(const Key('preview_back_button')), findsNothing);

    await cubit.close();
  });
}
