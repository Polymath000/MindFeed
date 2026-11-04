import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_state.dart';

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
  late ProfileInfoCubit cubit;

  const validAuthorId = '11111111-2222-3333-4444-555555555555';

  setUp(() {
    fakeProfileRepo = FakeProfileRepository();
    fakeArticlesRepo = FakeArticlesRepository();
    fakeFollowRepo = FakeAuthorFollowRepository();
    getUserProfileUseCase = GetUserProfileUseCase(fakeProfileRepo);
    getFavoriteCategoriesUseCase = GetFavoriteCategoriesUseCase(fakeProfileRepo);
    getArticlesByAuthorUseCase = GetArticlesByAuthorUseCase(fakeArticlesRepo);
    getAuthorFollowSummaryUseCase = GetAuthorFollowSummaryUseCase(fakeFollowRepo);
    cubit = ProfileInfoCubit(
      getUserProfileUseCase: getUserProfileUseCase,
      getFavoriteCategoriesUseCase: getFavoriteCategoriesUseCase,
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      getAuthorFollowSummaryUseCase: getAuthorFollowSummaryUseCase,
      userId: validAuthorId,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ProfileInfoCubit', () {
    test('initial state is ProfileInfoInitial with 0 followers and following', () {
      expect(cubit.state, isA<ProfileInfoInitial>());
      expect(cubit.state.followersCount, 0);
      expect(cubit.state.followingAuthorsCount, 0);
    });

    test(
        'loadProfileData emits ProfileInfoLoaded with remote profile, categories, follow summary, and published-only articles count',
        () async {
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
        ArticleEntity(
          id: '1',
          title: 'Story 1',
          slug: 'story-1',
          excerpt: 'Excerpt 1',
          status: 'published',
        ),
        ArticleEntity(
          id: '2',
          title: 'Story 2',
          slug: 'story-2',
          excerpt: 'Excerpt 2',
          status: 'published',
        ),
        ArticleEntity(
          id: '3',
          title: 'Draft 3',
          slug: 'draft-3',
          excerpt: 'Excerpt 3',
          status: 'draft',
        ),
      ];
      fakeFollowRepo.summary = const AuthorFollowSummary(
        followersCount: 120,
        followingCount: 35,
      );

      await cubit.loadProfileData(userId: validAuthorId);

      expect(cubit.state, isA<ProfileInfoLoaded>());
      final loaded = cubit.state as ProfileInfoLoaded;
      expect(loaded.displayName, 'Alice Engineer');
      expect(loaded.userSubtitle, 'Staff Software Architect');
      expect(loaded.avatarUrl, 'https://example.com/alice.png');
      expect(loaded.followingCount, 2); // Topics
      expect(loaded.followersCount, 120); // Followers
      expect(loaded.followingAuthorsCount, 35); // Following authors
      expect(loaded.articlesCount, 2); // Published articles only! Excludes draft 3
    });

    test('loadProfileData retains previous values when remote calls fail', () async {
      fakeProfileRepo.shouldProfileSucceed = false;
      fakeProfileRepo.shouldFavsSucceed = false;
      fakeArticlesRepo.shouldLoadSucceed = false;
      fakeFollowRepo.shouldSucceed = false;

      final initialDisplayName = cubit.state.displayName;

      await cubit.loadProfileData(userId: validAuthorId);

      expect(cubit.state, isA<ProfileInfoLoaded>());
      expect(cubit.state.displayName, initialDisplayName);
    });
  });
}
