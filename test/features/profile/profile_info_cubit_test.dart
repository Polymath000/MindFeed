import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_state.dart';
import 'fake_articles_repository.dart';
import 'fake_profile_repository.dart';

void main() {
  late FakeProfileRepository fakeProfileRepo;
  late FakeArticlesRepository fakeArticlesRepo;
  late GetUserProfileUseCase getUserProfileUseCase;
  late GetFavoriteCategoriesUseCase getFavoriteCategoriesUseCase;
  late GetArticlesByAuthorUseCase getArticlesByAuthorUseCase;
  late ProfileInfoCubit cubit;

  setUp(() {
    fakeProfileRepo = FakeProfileRepository();
    fakeArticlesRepo = FakeArticlesRepository();
    getUserProfileUseCase = GetUserProfileUseCase(fakeProfileRepo);
    getFavoriteCategoriesUseCase = GetFavoriteCategoriesUseCase(fakeProfileRepo);
    getArticlesByAuthorUseCase = GetArticlesByAuthorUseCase(fakeArticlesRepo);
    cubit = ProfileInfoCubit(
      getUserProfileUseCase: getUserProfileUseCase,
      getFavoriteCategoriesUseCase: getFavoriteCategoriesUseCase,
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      userId: 'test-user-id',
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ProfileInfoCubit', () {
    test('initial state is ProfileInfoInitial', () {
      expect(cubit.state, isA<ProfileInfoInitial>());
    });

    test('loadProfileData emits ProfileInfoLoaded with remote profile, categories, and articles count', () async {
      fakeProfileRepo.profileData = {
        'display_name': 'Alice Engineer',
        'bio': 'Staff Software Architect',
        'avatar_url': 'https://example.com/alice.png',
      };
      fakeProfileRepo.favoriteCategories = [
        {'id': 'cat-1', 'name': 'Tech'},
        {'id': 'cat-2', 'name': 'Science'},
      ];
      fakeArticlesRepo.authorArticles = const [
        ArticleEntity(id: '1', title: 'Story 1', slug: 'story-1', excerpt: 'Excerpt 1'),
        ArticleEntity(id: '2', title: 'Story 2', slug: 'story-2', excerpt: 'Excerpt 2'),
        ArticleEntity(id: '3', title: 'Story 3', slug: 'story-3', excerpt: 'Excerpt 3'),
      ];

      await cubit.loadProfileData(userId: 'test-user-id');

      expect(cubit.state, isA<ProfileInfoLoaded>());
      final loaded = cubit.state as ProfileInfoLoaded;
      expect(loaded.displayName, 'Alice Engineer');
      expect(loaded.userSubtitle, 'Staff Software Architect');
      expect(loaded.avatarUrl, 'https://example.com/alice.png');
      expect(loaded.followingCount, 2);
      expect(loaded.articlesCount, 3);
    });

    test('loadProfileData retains previous values when remote calls fail', () async {
      fakeProfileRepo.shouldProfileSucceed = false;
      fakeProfileRepo.shouldFavsSucceed = false;
      fakeArticlesRepo.shouldLoadSucceed = false;

      final initialDisplayName = cubit.state.displayName;

      await cubit.loadProfileData(userId: 'test-user-id');

      expect(cubit.state, isA<ProfileInfoLoaded>());
      expect(cubit.state.displayName, initialDisplayName);
    });
  });
}
