import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/features/author/domain/usecases/load_author_profile_dossier_use_case.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/author/presentation/views/author_view.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'fake_author_articles_repository.dart';

void main() {
  late FakeAuthorArticlesRepository fakeArticlesRepo;
  late FakeAuthorFollowRepository fakeFollowRepo;
  late GetHomeFeedUseCase getHomeFeedUseCase;
  late GetAuthorFollowSummaryUseCase getAuthorFollowSummaryUseCase;
  late ToggleAuthorFollowUseCase toggleAuthorFollowUseCase;

  const otherAuthorUuid = '11111111-1111-1111-1111-111111111111';
  const viewerUuid = '22222222-2222-2222-2222-222222222222';

  const sampleAuthorArticle = ArticleEntity(
    id: 'wade-story-1',
    authorId: otherAuthorUuid,
    title: 'Future of Silicon Chips',
    slug: 'silicon-chips',
    excerpt: 'Detailed overview of next-gen silicon chips.',
    authorName: 'Wade Warren',
    status: 'published',
    badge: 'HARDWARE',
  );

  setUp(() {
    fakeArticlesRepo = FakeAuthorArticlesRepository();
    fakeFollowRepo = FakeAuthorFollowRepository();
    getHomeFeedUseCase = GetHomeFeedUseCase(fakeArticlesRepo);
    getAuthorFollowSummaryUseCase =
        GetAuthorFollowSummaryUseCase(fakeFollowRepo);
    toggleAuthorFollowUseCase = ToggleAuthorFollowUseCase(fakeFollowRepo);
  });

  Widget buildTestWidget(
    AuthorCubit cubit, {
    String authorName = 'Wade Warren',
    String? authorRole,
    String? authorId,
  }) {
    return MaterialApp(
      home: AuthorView(
        cubit: cubit,
        authorName: authorName,
        authorRole: authorRole,
        authorId: authorId,
      ),
    );
  }

  testWidgets('renders author articles when cubit loads articles successfully',
      (tester) async {
    fakeArticlesRepo.feedArticles = [sampleAuthorArticle];
    final cubit = AuthorCubit(getHomeFeedUseCase: getHomeFeedUseCase);

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadAuthorArticles('Wade Warren');
    await tester.pumpAndSettle();

    expect(find.text('Wade Warren'), findsOneWidget);
    expect(find.text('Published Stories'), findsOneWidget);
    expect(find.text('1 stories'), findsOneWidget);
    expect(find.text('Future of Silicon Chips'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders 0 stories when author has no articles', (tester) async {
    fakeArticlesRepo.feedArticles = [];
    final cubit = AuthorCubit(getHomeFeedUseCase: getHomeFeedUseCase);

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadAuthorArticles('Wade Warren');
    await tester.pumpAndSettle();

    expect(find.text('0 stories'), findsOneWidget);
    expect(find.text('Future of Silicon Chips'), findsNothing);

    await cubit.close();
  });

  testWidgets('renders dossier header with real metrics and zero 86/48.2K/192',
      (tester) async {
    fakeArticlesRepo.feedArticles = [sampleAuthorArticle];
    fakeFollowRepo.followersCount = 5;

    final dossierUseCase = LoadAuthorProfileDossierUseCase(
      getHomeFeedUseCase: getHomeFeedUseCase,
      getAuthorFollowSummaryUseCase: getAuthorFollowSummaryUseCase,
    );
    final cubit = AuthorCubit(
      loadAuthorProfileDossierUseCase: dossierUseCase,
      viewerUserId: viewerUuid,
    );

    await tester.pumpWidget(
      buildTestWidget(
        cubit,
        authorName: 'Wade Warren',
        authorRole: 'Tech Journalist',
        authorId: otherAuthorUuid,
      ),
    );
    await cubit.loadAuthorArticles('Wade Warren', authorId: otherAuthorUuid);
    await tester.pumpAndSettle();

    expect(find.text('COLUMNIST DOSSIER'), findsOneWidget);
    expect(find.text('Tech Journalist'), findsOneWidget);
    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Rating'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);

    // Hardcoded stats from old design must never appear
    expect(find.text('86'), findsNothing);
    expect(find.text('48.2K'), findsNothing);
    expect(find.text('192'), findsNothing);

    await cubit.close();
  });

  testWidgets(
      'shows follow button when viewing another UUID author and hides it when self',
      (tester) async {
    fakeArticlesRepo.feedArticles = [sampleAuthorArticle];
    fakeFollowRepo.followersCount = 12;

    final dossierUseCase = LoadAuthorProfileDossierUseCase(
      getHomeFeedUseCase: getHomeFeedUseCase,
      getAuthorFollowSummaryUseCase: getAuthorFollowSummaryUseCase,
    );

    // Viewing another author: follow button visible
    final cubitViewingOther = AuthorCubit(
      loadAuthorProfileDossierUseCase: dossierUseCase,
      toggleAuthorFollowUseCase: toggleAuthorFollowUseCase,
      viewerUserId: viewerUuid,
    );

    await tester.pumpWidget(
      buildTestWidget(
        cubitViewingOther,
        authorName: 'Wade Warren',
        authorId: otherAuthorUuid,
      ),
    );
    await cubitViewingOther.loadAuthorArticles('Wade Warren',
        authorId: otherAuthorUuid);
    await tester.pumpAndSettle();

    expect(find.text('Follow'), findsOneWidget);
    await cubitViewingOther.close();

    // Viewing self: follow button hidden
    final cubitViewingSelf = AuthorCubit(
      loadAuthorProfileDossierUseCase: dossierUseCase,
      toggleAuthorFollowUseCase: toggleAuthorFollowUseCase,
      viewerUserId: otherAuthorUuid,
    );

    await tester.pumpWidget(
      buildTestWidget(
        cubitViewingSelf,
        authorName: 'Wade Warren',
        authorId: otherAuthorUuid,
      ),
    );
    await cubitViewingSelf.loadAuthorArticles('Wade Warren',
        authorId: otherAuthorUuid);
    await tester.pumpAndSettle();

    expect(find.text('Follow'), findsNothing);
    await cubitViewingSelf.close();
  });

  testWidgets(
      'shows follow button and toggles Follow -> Following on seeded editorial author (null authorId)',
      (tester) async {
    const seededArticle = ArticleEntity(
      id: 'seed-elena-1',
      authorId: null,
      title: 'Quantum Coherence Achieved at Room Temperature',
      slug: 'quantum-coherence',
      excerpt: 'Physicists sustained quantum entanglement...',
      authorName: 'Dr. Elena Rostova',
      status: 'published',
      badge: 'SCIENCE',
    );
    fakeArticlesRepo.feedArticles = [seededArticle];
    fakeFollowRepo.followersCount = 3;
    fakeFollowRepo.isFollowing = false;

    final dossierUseCase = LoadAuthorProfileDossierUseCase(
      getHomeFeedUseCase: getHomeFeedUseCase,
      getAuthorFollowSummaryUseCase: getAuthorFollowSummaryUseCase,
    );
    final cubit = AuthorCubit(
      loadAuthorProfileDossierUseCase: dossierUseCase,
      toggleAuthorFollowUseCase: toggleAuthorFollowUseCase,
      viewerUserId: viewerUuid,
    );

    await tester.pumpWidget(
      buildTestWidget(
        cubit,
        authorName: 'Dr. Elena Rostova',
        authorRole: 'Astrophysics Lead',
        authorId: null,
      ),
    );
    await cubit.loadAuthorArticles('Dr. Elena Rostova');
    await tester.pumpAndSettle();

    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();

    expect(find.text('Following'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders dynamic author details properly and share is absent',
      (tester) async {
    final cubit = AuthorCubit(getHomeFeedUseCase: getHomeFeedUseCase);

    await tester.pumpWidget(
      buildTestWidget(
        cubit,
        authorName: 'Ada Lovelace',
        authorRole: 'Chief Pioneer',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Chief Pioneer'), findsOneWidget);
    expect(find.bySemanticsLabel('Share profile'), findsNothing);

    await cubit.close();
  });
}
