import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/data/datasources/articles_local_data_source.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/repos/author_follow_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/article/domain/usecases/check_article_downloaded_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_liked_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_saved_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_author_bar.dart';

class _FakeFollowRepo implements AuthorFollowRepository {
  bool isFollowing = false;
  int followersCount = 10;
  bool shouldFail = false;

  @override
  Future<ApiResult<AuthorFollowSummary>> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  }) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Failed to load summary'));
    }
    return Success(AuthorFollowSummary(
      isFollowing: isFollowing,
      followersCount: followersCount,
      followingCount: 5,
    ));
  }

  @override
  Future<ApiResult<void>> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  }) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Follow request failed'));
    }
    isFollowing = true;
    followersCount++;
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  }) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Unfollow request failed'));
    }
    isFollowing = false;
    followersCount--;
    return const Success(null);
  }
}

class _FakeArticlesRepo
    implements ArticlesRepository, ArticleEngagementRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async =>
      const Success(AuthorRatingSummary(
        authorKey: 'author-1',
        userStars: 0,
        ratingAvg: 0.0,
        ratingCount: 0,
      ));

  @override
  Future<ApiResult<bool>> isArticleLiked(
          String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<bool>> isArticleSaved(
          String articleId, String userId) async =>
      const Success(false);
}

class _FakeLocalDataSource implements ArticlesLocalDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async =>
      null;
}

ArticleReaderCubit _createCubit({
  required _FakeFollowRepo followRepo,
  String? currentUserId = '11111111-1111-1111-1111-111111111111',
}) {
  final repo = _FakeArticlesRepo();
  final local = _FakeLocalDataSource();
  return ArticleReaderCubit(
    getArticleDetailsUseCase: GetArticleDetailsUseCase(repo),
    checkArticleDownloadedUseCase: CheckArticleDownloadedUseCase(local),
    downloadArticleTextUseCase: DownloadArticleTextUseCase(local),
    isArticleLikedUseCase: IsArticleLikedUseCase(repo),
    toggleArticleLikeUseCase: ToggleArticleLikeUseCase(repo),
    isArticleSavedUseCase: IsArticleSavedUseCase(repo),
    toggleBookmarkUseCase: ToggleBookmarkUseCase(repo),
    rateAuthorUseCase: RateAuthorUseCase(repo),
    getAuthorRatingUseCase: GetAuthorRatingUseCase(repo),
    getAuthorFollowSummaryUseCase: GetAuthorFollowSummaryUseCase(followRepo),
    toggleAuthorFollowUseCase: ToggleAuthorFollowUseCase(followRepo),
    currentUserId: currentUserId,
  );
}

EditorialNewsItem _createItem({
  String id = 'art-1',
  String? authorId,
  String authorName = 'Grace Hopper',
  String? content = 'Full story content',
}) {
  return EditorialNewsItem(
    id: id,
    badge: 'TECH',
    badgeColor: Colors.black,
    title: 'Test Title',
    updated: 'Just now',
    authorName: authorName,
    authorRole: 'Rear Admiral',
    authorAvatar: '',
    excerpt: 'excerpt',
    color: Colors.blue,
    authorId: authorId,
    content: content,
  );
}

void main() {
  testWidgets('renders author name and role properly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Ada Lovelace',
            authorRole: 'Chief Pioneer',
            authorAvatar: '',
          ),
        ),
      ),
    );

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Chief Pioneer'), findsOneWidget);
  });

  testWidgets('tapping author identity triggers onAuthorTap callback', (tester) async {
    bool authorTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Alan Turing',
            authorRole: 'Lead Cryptanalyst',
            authorAvatar: '',
            onAuthorTap: () => authorTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Alan Turing'));
    await tester.pumpAndSettle();

    expect(authorTapped, isTrue);
  });

  testWidgets('does not render follow button when canFollowAuthor is false', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Grace Hopper',
            authorRole: 'Rear Admiral',
            authorAvatar: '',
            canFollowAuthor: false,
          ),
        ),
      ),
    );

    expect(find.byType(EditorialFollowButton), findsNothing);
    expect(find.text('Follow'), findsNothing);
    expect(find.text('Following'), findsNothing);
  });

  testWidgets('renders Follow button when canFollowAuthor is true and isFollowingAuthor is false and invokes onToggleFollow', (tester) async {
    bool toggleTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Grace Hopper',
            authorRole: 'Rear Admiral',
            authorAvatar: '',
            canFollowAuthor: true,
            isFollowingAuthor: false,
            onToggleFollow: () => toggleTapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(EditorialFollowButton), findsOneWidget);
    expect(find.text('Follow'), findsOneWidget);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();

    expect(toggleTapped, isTrue);
  });

  testWidgets('renders Following button when canFollowAuthor is true and isFollowingAuthor is true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Grace Hopper',
            authorRole: 'Rear Admiral',
            authorAvatar: '',
            canFollowAuthor: true,
            isFollowingAuthor: true,
          ),
        ),
      ),
    );

    expect(find.byType(EditorialFollowButton), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Follow'), findsNothing);
  });

  testWidgets('shows loading indicator on follow button when isFollowLoading is true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Grace Hopper',
            authorRole: 'Rear Admiral',
            authorAvatar: '',
            canFollowAuthor: true,
            isFollowLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  group('ArticleReaderCubit follow integration tests', () {
    test('initArticle with valid UUID author fetches follow summary', () async {
      final followRepo = _FakeFollowRepo()..isFollowing = true;
      final cubit = _createCubit(followRepo: followRepo);
      const authorId = '22222222-2222-2222-2222-222222222222';
      final item = _createItem(authorId: authorId);

      await cubit.initArticle(item);

      expect(cubit.state.canFollowAuthor, isTrue);
      expect(cubit.state.isFollowingAuthor, isTrue);
    });

    test('initArticle with self author sets canFollowAuthor to false', () async {
      final followRepo = _FakeFollowRepo();
      final cubit = _createCubit(
        followRepo: followRepo,
        currentUserId: '11111111-1111-1111-1111-111111111111',
      );
      final item = _createItem(authorId: '11111111-1111-1111-1111-111111111111');

      await cubit.initArticle(item);

      expect(cubit.state.canFollowAuthor, isFalse);
      expect(cubit.state.isFollowingAuthor, isFalse);
    });

    test('initArticle with seeded editorial author (null authorId) enables follow via authorKey', () async {
      final followRepo = _FakeFollowRepo()..isFollowing = false;
      final cubit = _createCubit(followRepo: followRepo);
      final item = _createItem(
        authorId: null,
        authorName: 'Dr. Elena Rostova',
      );

      await cubit.initArticle(item);

      expect(cubit.state.canFollowAuthor, isTrue);
      expect(cubit.state.isFollowingAuthor, isFalse);

      await cubit.toggleFollowAuthor();
      expect(cubit.state.isFollowingAuthor, isTrue);
      expect(cubit.state.userFeedback, 'Following Dr. Elena Rostova');
    });

    test('toggleFollowAuthor follows author and emits success feedback', () async {
      final followRepo = _FakeFollowRepo()..isFollowing = false;
      final cubit = _createCubit(followRepo: followRepo);
      const authorId = '22222222-2222-2222-2222-222222222222';
      final item = _createItem(
        authorId: authorId,
        authorName: 'Grace Hopper',
      );

      await cubit.initArticle(item);
      expect(cubit.state.isFollowingAuthor, isFalse);

      await cubit.toggleFollowAuthor();

      expect(cubit.state.isFollowingAuthor, isTrue);
      expect(cubit.state.userFeedback, 'Following Grace Hopper');
      expect(cubit.state.feedbackMessage, 'Following Grace Hopper');
    });

    test('toggleFollowAuthor unfollows author and emits success feedback', () async {
      final followRepo = _FakeFollowRepo()..isFollowing = true;
      final cubit = _createCubit(followRepo: followRepo);
      const authorId = '22222222-2222-2222-2222-222222222222';
      final item = _createItem(
        authorId: authorId,
        authorName: 'Grace Hopper',
      );

      await cubit.initArticle(item);
      expect(cubit.state.isFollowingAuthor, isTrue);

      await cubit.toggleFollowAuthor();

      expect(cubit.state.isFollowingAuthor, isFalse);
      expect(cubit.state.userFeedback, 'Unfollowed Grace Hopper');
    });

    test('toggleFollowAuthor emits error message on failure', () async {
      final followRepo = _FakeFollowRepo()..isFollowing = false;
      final cubit = _createCubit(followRepo: followRepo);
      const authorId = '22222222-2222-2222-2222-222222222222';
      final item = _createItem(
        authorId: authorId,
        authorName: 'Grace Hopper',
      );

      await cubit.initArticle(item);
      followRepo.shouldFail = true;

      await cubit.toggleFollowAuthor();

      expect(cubit.state.isFollowingAuthor, isFalse);
      expect(cubit.state.userFeedback, 'Follow request failed');
    });
  });
}
