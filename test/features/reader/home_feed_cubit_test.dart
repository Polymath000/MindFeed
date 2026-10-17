import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/presentation/cubit/home_feed/home_feed_cubit.dart';
import 'package:mind_feed/features/home/presentation/cubit/home_feed/home_feed_state.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class _FakeArticlesRepo implements ArticlesRepository {
  bool shouldFail = false;
  String failureMessage = 'Network error occurred';
  List<ArticleEntity> articles = [];

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    if (shouldFail) {
      return FailureResult(ServerFailure(failureMessage));
    }
    return Success(articles);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProfileRepo implements ProfileRepository {
  List<Map<String, dynamic>> favoriteCategories = [];
  List<Map<String, dynamic>> allCategories = [];

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(
      String userId) async {
    return Success(favoriteCategories);
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getCategories() async {
    return Success(allCategories);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeArticlesRepo fakeArticlesRepo;
  late _FakeProfileRepo fakeProfileRepo;
  late GetHomeFeedUseCase feedUseCase;

  const sampleArticle1 = ArticleEntity(
    id: 'art_1',
    title: 'Breakthrough in AI Research',
    slug: 'breakthrough-in-ai',
    excerpt: 'New model shows reasoning capabilities.',
    badge: 'TECH',
    tags: ['AI', 'Tech'],
  );

  const sampleArticle2 = ArticleEntity(
    id: 'art_2',
    title: 'New Space Telescope Images',
    slug: 'new-space-telescope',
    excerpt: 'Deep field view reveals early galaxies.',
    badge: 'SCIENCE',
    tags: ['Space', 'Science'],
  );

  setUp(() {
    fakeArticlesRepo = _FakeArticlesRepo();
    fakeProfileRepo = _FakeProfileRepo();
    fakeArticlesRepo.articles = [sampleArticle1, sampleArticle2];
    feedUseCase = GetHomeFeedUseCase(fakeArticlesRepo);
  });

  test('initial state has default topics and All selected', () {
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
    );
    expect(cubit.state.status, equals(HomeFeedStatus.initial));
    expect(cubit.state.selectedTopic, equals('All'));
    expect(cubit.state.topics, contains('All'));
    expect(cubit.state.allArticles, isEmpty);
    cubit.close();
  });

  test('fetchFeed successfully populates articles and preserves filtering',
      () async {
    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
      currentUserId: 'user_123',
    );

    await cubit.fetchFeed();

    expect(cubit.state.status, equals(HomeFeedStatus.success));
    expect(cubit.state.allArticles.length, equals(2));
    expect(cubit.state.filteredArticles.length, equals(2));

    cubit.selectTopic('Tech');
    expect(cubit.state.selectedTopic, equals('Tech'));
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.title,
        equals('Breakthrough in AI Research'));

    cubit.selectTopic('Science');
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.title,
        equals('New Space Telescope Images'));

    cubit.close();
  });

  test('fetchFeed handles offline and network errors gracefully', () async {
    fakeArticlesRepo.shouldFail = true;
    fakeArticlesRepo.failureMessage = 'SocketException: network is offline';

    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
    );

    await cubit.fetchFeed();

    expect(cubit.state.status, equals(HomeFeedStatus.error));
    expect(cubit.state.errorMessage, contains('currently offline'));

    cubit.close();
  });

  test('fetchFeed resolves dynamic favorite categories for logged in user',
      () async {
    fakeProfileRepo.favoriteCategories = [
      {
        'category_id': 'cat_eco',
        'categories': {'name': 'Ecology'},
      }
    ];

    final cubit = HomeFeedCubit(
      getHomeFeedUseCase: feedUseCase,
      profileRepository: fakeProfileRepo,
      currentUserId: 'user_456',
    );

    await cubit.fetchFeed();

    expect(cubit.state.status, equals(HomeFeedStatus.success));
    expect(cubit.state.topics, contains('Ecology'));

    cubit.close();
  });
}
