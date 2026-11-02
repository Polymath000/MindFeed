import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/widgets/personal_infromation.dart';

import 'fake_articles_repository.dart';
import 'fake_author_follow_repository.dart';
import 'fake_profile_repository.dart';

void main() {
  late FakeProfileRepository fakeProfileRepo;
  late FakeArticlesRepository fakeArticlesRepo;
  late FakeAuthorFollowRepository fakeFollowRepo;
  late GetUserProfileUseCase getUserProfileUseCase;
  late GetFavoriteCategoriesUseCase getFavoriteCategoriesUseCase;
  late GetArticlesByAuthorUseCase getArticlesByAuthorUseCase;
  late GetAuthorFollowSummaryUseCase getAuthorFollowSummaryUseCase;

  const validAuthorId = '11111111-2222-3333-4444-555555555555';

  setUp(() {
    fakeProfileRepo = FakeProfileRepository();
    fakeArticlesRepo = FakeArticlesRepository();
    fakeFollowRepo = FakeAuthorFollowRepository();
    getUserProfileUseCase = GetUserProfileUseCase(fakeProfileRepo);
    getFavoriteCategoriesUseCase = GetFavoriteCategoriesUseCase(fakeProfileRepo);
    getArticlesByAuthorUseCase = GetArticlesByAuthorUseCase(fakeArticlesRepo);
    getAuthorFollowSummaryUseCase = GetAuthorFollowSummaryUseCase(fakeFollowRepo);
  });

  Widget buildTestWidget({ProfileInfoCubit? cubit}) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            PersonalInfromation(cubit: cubit),
          ],
        ),
      ),
    );
  }

  testWidgets('renders PersonalInfromation fallback without cubit or DI safely with 4 stats', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(PersonalInfromation), findsOneWidget);
    expect(find.text('Articles'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Topics'), findsOneWidget);
  });

  testWidgets('renders updated personal information and 4 stats when cubit emits loaded state', (tester) async {
    fakeProfileRepo.profileData = {
      'display_name': 'Grace Hopper',
      'bio': 'Pioneer of Computer Programming',
      'avatar_url': 'https://example.com/grace.png',
    };
    fakeProfileRepo.favoriteCategories = [
      {'id': '1', 'name': 'CompSci'},
      {'id': '2', 'name': 'Mathematics'},
    ];
    fakeArticlesRepo.authorArticles = const [
      ArticleEntity(
        id: '1',
        title: 'Compiler Design',
        slug: 'compiler-design',
        excerpt: 'Foundations of compiling.',
        status: 'published',
      ),
      ArticleEntity(
        id: '2',
        title: 'Draft in Progress',
        slug: 'draft-in-progress',
        excerpt: 'Unpublished draft.',
        status: 'draft',
      ),
    ];
    fakeFollowRepo.summary = const AuthorFollowSummary(
      followersCount: 42,
      followingCount: 15,
    );

    final cubit = ProfileInfoCubit(
      getUserProfileUseCase: getUserProfileUseCase,
      getFavoriteCategoriesUseCase: getFavoriteCategoriesUseCase,
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      getAuthorFollowSummaryUseCase: getAuthorFollowSummaryUseCase,
      userId: validAuthorId,
    );

    await tester.pumpWidget(buildTestWidget(cubit: cubit));
    await cubit.loadProfileData(userId: validAuthorId);
    await tester.pumpAndSettle();

    expect(find.text('Grace Hopper'), findsOneWidget);
    expect(find.text('Pioneer of Computer Programming'), findsOneWidget);

    // 4 Stat Labels
    expect(find.text('Articles'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Topics'), findsOneWidget);

    // Stat Values:
    // Articles = 1 (published only, excludes draft)
    expect(find.text('1'), findsOneWidget);
    // Followers = 42
    expect(find.text('42'), findsOneWidget);
    // Following = 15
    expect(find.text('15'), findsOneWidget);
    // Topics = 2
    expect(find.text('2'), findsOneWidget);

    await cubit.close();
  });
}
