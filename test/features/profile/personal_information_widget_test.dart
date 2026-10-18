import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/widgets/personal_infromation.dart';
import 'fake_articles_repository.dart';
import 'fake_profile_repository.dart';

void main() {
  late FakeProfileRepository fakeProfileRepo;
  late FakeArticlesRepository fakeArticlesRepo;
  late GetUserProfileUseCase getUserProfileUseCase;
  late GetFavoriteCategoriesUseCase getFavoriteCategoriesUseCase;
  late GetArticlesByAuthorUseCase getArticlesByAuthorUseCase;

  setUp(() {
    fakeProfileRepo = FakeProfileRepository();
    fakeArticlesRepo = FakeArticlesRepository();
    getUserProfileUseCase = GetUserProfileUseCase(fakeProfileRepo);
    getFavoriteCategoriesUseCase = GetFavoriteCategoriesUseCase(fakeProfileRepo);
    getArticlesByAuthorUseCase = GetArticlesByAuthorUseCase(fakeArticlesRepo);
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

  testWidgets('renders PersonalInfromation fallback without cubit or DI safely', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(PersonalInfromation), findsOneWidget);
    expect(find.text('Articles'), findsOneWidget);
    expect(find.text('Topics'), findsOneWidget);
  });

  testWidgets('renders updated personal information when cubit emits loaded state', (tester) async {
    fakeProfileRepo.profileData = {
      'display_name': 'Grace Hopper',
      'bio': 'Pioneer of Computer Programming',
      'avatar_url': 'https://example.com/grace.png',
    };
    fakeProfileRepo.favoriteCategories = [
      {'id': '1', 'name': 'CompSci'},
    ];
    fakeArticlesRepo.authorArticles = const [
      ArticleEntity(
        id: '1',
        title: 'Compiler Design',
        slug: 'compiler-design',
        excerpt: 'Foundations of compiling.',
      ),
    ];

    final cubit = ProfileInfoCubit(
      getUserProfileUseCase: getUserProfileUseCase,
      getFavoriteCategoriesUseCase: getFavoriteCategoriesUseCase,
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      userId: 'test-user',
    );

    await tester.pumpWidget(buildTestWidget(cubit: cubit));
    await cubit.loadProfileData(userId: 'test-user');
    await tester.pumpAndSettle();

    expect(find.text('Grace Hopper'), findsOneWidget);
    expect(find.text('Pioneer of Computer Programming'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2)); // 1 article, 1 topic

    await cubit.close();
  });
}
