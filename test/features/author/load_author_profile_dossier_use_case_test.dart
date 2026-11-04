import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/author/domain/usecases/load_author_profile_dossier_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'fake_author_articles_repository.dart';

void main() {
  late FakeAuthorArticlesRepository fakeArticlesRepo;
  late FakeAuthorFollowRepository fakeFollowRepo;
  late FakeAuthorEngagementRepository fakeEngagementRepo;
  late FakeProfileRepository fakeProfileRepo;

  late GetHomeFeedUseCase getHomeFeedUseCase;
  late GetArticlesByAuthorUseCase getArticlesByAuthorUseCase;
  late GetAuthorFollowSummaryUseCase getAuthorFollowSummaryUseCase;
  late GetAuthorRatingUseCase getAuthorRatingUseCase;
  late GetUserProfileUseCase getUserProfileUseCase;

  late LoadAuthorProfileDossierUseCase useCase;

  const authorUuid = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
  const viewerUuid = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';

  const published1 = ArticleEntity(
    id: 'art-1',
    authorId: authorUuid,
    authorName: 'Grace Hopper',
    title: 'Compilers in Depth',
    slug: 'compilers-in-depth',
    excerpt: 'History and future of compilers.',
    badge: 'SYSTEMS',
    status: 'published',
  );

  const draft1 = ArticleEntity(
    id: 'art-draft',
    authorId: authorUuid,
    authorName: 'Grace Hopper',
    title: 'Unpublished Draft',
    slug: 'unpublished-draft',
    excerpt: 'Notes only.',
    badge: 'SYSTEMS',
    status: 'draft',
  );

  setUp(() {
    fakeArticlesRepo = FakeAuthorArticlesRepository();
    fakeFollowRepo = FakeAuthorFollowRepository();
    fakeEngagementRepo = FakeAuthorEngagementRepository();
    fakeProfileRepo = FakeProfileRepository();

    getHomeFeedUseCase = GetHomeFeedUseCase(fakeArticlesRepo);
    getArticlesByAuthorUseCase = GetArticlesByAuthorUseCase(fakeArticlesRepo);
    getAuthorFollowSummaryUseCase =
        GetAuthorFollowSummaryUseCase(fakeFollowRepo);
    getAuthorRatingUseCase = GetAuthorRatingUseCase(fakeEngagementRepo);
    getUserProfileUseCase = GetUserProfileUseCase(fakeProfileRepo);

    useCase = LoadAuthorProfileDossierUseCase(
      getHomeFeedUseCase: getHomeFeedUseCase,
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      getUserProfileUseCase: getUserProfileUseCase,
      getAuthorFollowSummaryUseCase: getAuthorFollowSummaryUseCase,
      getAuthorRatingUseCase: getAuthorRatingUseCase,
    );
  });

  test('filters out drafts and extracts distinct topics', () async {
    fakeArticlesRepo.feedArticles = [published1, draft1];

    final result = await useCase(
      authorName: 'Grace Hopper',
      authorId: authorUuid,
      viewerUserId: viewerUuid,
    );

    expect(result, isA<Success>());
    final dossier = (result as Success).data;
    expect(dossier.publishedArticles.length, equals(1));
    expect(dossier.publishedArticles.first.id, equals('art-1'));
    expect(dossier.topics, equals(['SYSTEMS']));
    expect(dossier.canFollow, isTrue);
    expect(dossier.canRate, isTrue);
  });

  test('overrides display name, bio, and avatar from profile repository',
      () async {
    fakeArticlesRepo.feedArticles = [published1];
    fakeProfileRepo.profileData = {
      'display_name': 'Rear Admiral Grace Hopper',
      'bio': 'Pioneering computer scientist and naval officer.',
      'avatar_url': 'https://example.com/hopper.png',
    };

    final result = await useCase(
      authorName: 'Grace Hopper',
      authorId: authorUuid,
      viewerUserId: viewerUuid,
    );

    expect(result, isA<Success>());
    final dossier = (result as Success).data;
    expect(dossier.displayName, equals('Rear Admiral Grace Hopper'));
    expect(dossier.bio,
        equals('Pioneering computer scientist and naval officer.'));
    expect(dossier.avatarUrl, equals('https://example.com/hopper.png'));
  });

  test('marks canFollow and canRate as false when viewer is the author (self)',
      () async {
    fakeArticlesRepo.feedArticles = [published1];

    final result = await useCase(
      authorName: 'Grace Hopper',
      authorId: authorUuid,
      viewerUserId: authorUuid,
    );

    expect(result, isA<Success>());
    final dossier = (result as Success).data;
    expect(dossier.canFollow, isFalse);
    expect(dossier.canRate, isFalse);
  });

  test('enables canFollow via canonical authorKey for seeded authors without authorId',
      () async {
    const seeded = ArticleEntity(
      id: 'seed-1',
      authorId: null,
      authorName: 'Dr. Elena Rostova',
      title: 'Deep Space Survey',
      slug: 'deep-space',
      excerpt: 'JWST findings.',
      badge: 'SPACE',
      status: 'published',
    );
    fakeArticlesRepo.feedArticles = [seeded];
    fakeFollowRepo.followersCount = 8;

    final result = await useCase(
      authorName: 'Dr. Elena Rostova',
      authorId: null,
      viewerUserId: viewerUuid,
    );

    expect(result, isA<Success>());
    final dossier = (result as Success).data;
    expect(dossier.authorId, isNull);
    expect(dossier.authorKey, equals('dr. elena rostova'));
    expect(dossier.canFollow, isTrue);
    expect(dossier.followSummary.followersCount, equals(8));
  });

  test('returns FailureResult when fetching articles fails', () async {
    fakeArticlesRepo.shouldSucceed = false;
    fakeArticlesRepo.errorMessage = 'Database down';

    final result = await useCase(
      authorName: 'Grace Hopper',
      authorId: authorUuid,
    );

    expect(result, isA<FailureResult>());
  });
}
