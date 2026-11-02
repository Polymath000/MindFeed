import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/author/domain/usecases/load_author_profile_dossier_use_case.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_state.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'fake_author_articles_repository.dart';

void main() {
  late FakeAuthorArticlesRepository fakeArticlesRepo;
  late FakeAuthorFollowRepository fakeFollowRepo;
  late FakeAuthorEngagementRepository fakeEngagementRepo;

  late GetHomeFeedUseCase getHomeFeedUseCase;
  late GetArticlesByAuthorUseCase getArticlesByAuthorUseCase;
  late GetAuthorFollowSummaryUseCase getAuthorFollowSummaryUseCase;
  late ToggleAuthorFollowUseCase toggleAuthorFollowUseCase;
  late GetAuthorRatingUseCase getAuthorRatingUseCase;
  late RateAuthorUseCase rateAuthorUseCase;
  late LoadAuthorProfileDossierUseCase loadAuthorProfileDossierUseCase;
  late AuthorCubit cubit;

  const validAuthorUuid = '11111111-1111-1111-1111-111111111111';
  const validViewerUuid = '22222222-2222-2222-2222-222222222222';

  const publishedArticle1 = ArticleEntity(
    id: 'wade-1',
    authorId: validAuthorUuid,
    title: 'The AI Revolution',
    slug: 'ai-revolution',
    excerpt: 'An in-depth look at AI.',
    authorName: 'Wade Warren',
    badge: 'TECH',
    status: 'published',
  );

  const publishedArticle2 = ArticleEntity(
    id: 'wade-2',
    authorId: validAuthorUuid,
    title: 'Biotech Breakthroughs',
    slug: 'biotech-breakthroughs',
    excerpt: 'Genomics in 2026.',
    authorName: 'Wade Warren',
    badge: 'SCIENCE',
    status: 'published',
  );

  const draftArticle = ArticleEntity(
    id: 'wade-draft',
    authorId: validAuthorUuid,
    title: 'Secret Draft Story',
    slug: 'secret-draft',
    excerpt: 'Private draft notes.',
    authorName: 'Wade Warren',
    badge: 'CONFIDENTIAL',
    status: 'draft',
  );

  const otherAuthorArticle = ArticleEntity(
    id: 'other-1',
    authorId: '33333333-3333-3333-3333-333333333333',
    title: 'Global Markets',
    slug: 'global-markets',
    excerpt: 'Market trends overview.',
    authorName: 'Jane Doe',
    status: 'published',
  );

  setUp(() {
    fakeArticlesRepo = FakeAuthorArticlesRepository();
    fakeFollowRepo = FakeAuthorFollowRepository();
    fakeEngagementRepo = FakeAuthorEngagementRepository();

    getHomeFeedUseCase = GetHomeFeedUseCase(fakeArticlesRepo);
    getArticlesByAuthorUseCase = GetArticlesByAuthorUseCase(fakeArticlesRepo);
    getAuthorFollowSummaryUseCase =
        GetAuthorFollowSummaryUseCase(fakeFollowRepo);
    toggleAuthorFollowUseCase = ToggleAuthorFollowUseCase(fakeFollowRepo);
    getAuthorRatingUseCase = GetAuthorRatingUseCase(fakeEngagementRepo);
    rateAuthorUseCase = RateAuthorUseCase(fakeEngagementRepo);

    loadAuthorProfileDossierUseCase = LoadAuthorProfileDossierUseCase(
      getHomeFeedUseCase: getHomeFeedUseCase,
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      getAuthorFollowSummaryUseCase: getAuthorFollowSummaryUseCase,
      getAuthorRatingUseCase: getAuthorRatingUseCase,
    );

    cubit = AuthorCubit(
      loadAuthorProfileDossierUseCase: loadAuthorProfileDossierUseCase,
      toggleAuthorFollowUseCase: toggleAuthorFollowUseCase,
      rateAuthorUseCase: rateAuthorUseCase,
      viewerUserId: validViewerUuid,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthorCubit', () {
    test('initial state is AuthorInitial', () {
      expect(cubit.state, equals(const AuthorInitial()));
    });

    test(
        'emits [AuthorLoading, AuthorLoaded] and excludes draft stories (published only)',
        () async {
      fakeArticlesRepo.feedArticles = [
        publishedArticle1,
        draftArticle,
        otherAuthorArticle,
      ];

      final expectedStates = [
        const AuthorLoading(),
        isA<AuthorLoaded>()
            .having((s) => s.articles.length, 'length', 1)
            .having((s) => s.articles.first.id, 'id', 'wade-1')
            .having((s) => s.topics, 'topics', ['TECH'])
            .having((s) => s.canFollow, 'canFollow', true),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren', authorId: validAuthorUuid);
    });

    test(
        'emits [AuthorLoading, AuthorLoaded] with matching author articles via authorName fallback',
        () async {
      fakeArticlesRepo.feedArticles = [publishedArticle1, otherAuthorArticle];

      final expectedStates = [
        const AuthorLoading(),
        isA<AuthorLoaded>()
            .having((s) => s.articles.length, 'length', 1)
            .having((s) => s.articles.first.id, 'id', 'wade-1'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren');
    });

    test('emits [AuthorLoading, AuthorEmpty] when author has no matching articles',
        () async {
      fakeArticlesRepo.feedArticles = [otherAuthorArticle];

      final expectedStates = [
        const AuthorLoading(),
        isA<AuthorEmpty>()
            .having((s) => s.articles.isEmpty, 'empty articles', true)
            .having((s) => s.displayName, 'displayName', 'Wade Warren'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren');
    });

    test('filters articles correctly via selectTopic', () async {
      fakeArticlesRepo.feedArticles = [publishedArticle1, publishedArticle2];
      await cubit.loadAuthorArticles('Wade Warren', authorId: validAuthorUuid);

      expect(cubit.state, isA<AuthorLoaded>());
      final loadedBefore = cubit.state as AuthorLoaded;
      expect(loadedBefore.articles.length, equals(2));
      expect(loadedBefore.filteredArticles.length, equals(2));

      cubit.selectTopic('SCIENCE');
      final loadedScience = cubit.state as AuthorLoaded;
      expect(loadedScience.selectedTopic, equals('SCIENCE'));
      expect(loadedScience.filteredArticles.length, equals(1));
      expect(loadedScience.filteredArticles.first.title,
          equals('Biotech Breakthroughs'));

      cubit.selectTopic(null);
      final loadedAll = cubit.state as AuthorLoaded;
      expect(loadedAll.selectedTopic, isNull);
      expect(loadedAll.filteredArticles.length, equals(2));
    });

    test('toggleFollow updates followersCount and isFollowing live', () async {
      fakeArticlesRepo.feedArticles = [publishedArticle1];
      fakeFollowRepo.followersCount = 10;
      fakeFollowRepo.isFollowing = false;

      await cubit.loadAuthorArticles('Wade Warren', authorId: validAuthorUuid);
      final initialState = cubit.state as AuthorLoaded;
      expect(initialState.isFollowing, isFalse);
      expect(initialState.followersCount, equals(10));

      await cubit.toggleFollow();
      final followedState = cubit.state as AuthorLoaded;
      expect(followedState.isFollowing, isTrue);
      expect(followedState.followersCount, equals(11));

      await cubit.toggleFollow();
      final unfollowedState = cubit.state as AuthorLoaded;
      expect(unfollowedState.isFollowing, isFalse);
      expect(unfollowedState.followersCount, equals(10));
    });

    test('toggleFollow works on seeded editorial authors without UUID authorId',
        () async {
      const seededArticle = ArticleEntity(
        id: 'seed-1',
        authorId: null,
        title: 'James Webb Space Telescope Detects Water',
        slug: 'jwst-water',
        excerpt: 'Spectroscopic observations...',
        authorName: 'Dr. Elena Rostova',
        badge: 'SPACE',
        status: 'published',
      );
      fakeArticlesRepo.feedArticles = [seededArticle];
      fakeFollowRepo.followersCount = 4;
      fakeFollowRepo.isFollowing = false;

      await cubit.loadAuthorArticles('Dr. Elena Rostova');
      final initialState = cubit.state as AuthorLoaded;
      expect(initialState.canFollow, isTrue);
      expect(initialState.authorId, isNull);
      expect(initialState.authorKey, equals('dr. elena rostova'));

      await cubit.toggleFollow();
      final followedState = cubit.state as AuthorLoaded;
      expect(followedState.isFollowing, isTrue);
      expect(followedState.followersCount, equals(5));
      expect(followedState.feedbackMessage, equals('Following Dr. Elena Rostova'));
      expect(fakeFollowRepo.lastAuthorKey, equals('dr. elena rostova'));
    });

    test('rateAuthor updates userStars, ratingAvg, and ratingCount live',
        () async {
      fakeArticlesRepo.feedArticles = [publishedArticle1];
      await cubit.loadAuthorArticles('Wade Warren', authorId: validAuthorUuid);

      await cubit.rateAuthor(5);
      final ratedState = cubit.state as AuthorLoaded;
      expect(ratedState.userStars, equals(5));
      expect(ratedState.ratingCount, equals(13));
      expect(ratedState.ratingAvg, equals(4.8));
    });

    test('emits [AuthorLoading, AuthorError] when getHomeFeed fails', () async {
      fakeArticlesRepo.shouldSucceed = false;
      fakeArticlesRepo.errorMessage = 'Network connection failed';

      final expectedStates = [
        const AuthorLoading(),
        const AuthorError('Network connection failed'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren');
    });

    test('emits [AuthorLoading, AuthorError] when getArticlesByAuthor fails',
        () async {
      fakeArticlesRepo.shouldSucceed = false;
      fakeArticlesRepo.errorMessage = 'Author service unavailable';

      final expectedStates = [
        const AuthorLoading(),
        const AuthorError('Author service unavailable'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren', authorId: validAuthorUuid);
    });
  });
}
