import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_state.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'fake_author_articles_repository.dart';

void main() {
  late FakeAuthorArticlesRepository fakeRepo;
  late GetHomeFeedUseCase getHomeFeedUseCase;
  late AuthorCubit cubit;

  const authorArticle = ArticleEntity(
    id: 'wade-1',
    title: 'The AI Revolution',
    slug: 'ai-revolution',
    excerpt: 'An in-depth look at AI.',
    authorName: 'Wade Warren',
  );

  const otherArticle = ArticleEntity(
    id: 'other-1',
    title: 'Global Markets',
    slug: 'global-markets',
    excerpt: 'Market trends overview.',
    authorName: 'Jane Doe',
  );

  setUp(() {
    fakeRepo = FakeAuthorArticlesRepository();
    getHomeFeedUseCase = GetHomeFeedUseCase(fakeRepo);
    cubit = AuthorCubit(getHomeFeedUseCase: getHomeFeedUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthorCubit', () {
    test('initial state is AuthorInitial', () {
      expect(cubit.state, equals(const AuthorInitial()));
    });

    test('emits [AuthorLoading, AuthorLoaded] with matching author articles', () async {
      fakeRepo.feedArticles = [authorArticle, otherArticle];

      final expectedStates = [
        const AuthorLoading(),
        isA<AuthorLoaded>()
            .having((s) => s.articles.length, 'length', 1)
            .having((s) => s.articles.first.id, 'id', 'wade-1'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren');
    });

    test('emits [AuthorLoading, AuthorEmpty] when author has no matching articles', () async {
      fakeRepo.feedArticles = [otherArticle];

      final expectedStates = [
        const AuthorLoading(),
        const AuthorEmpty(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren');
    });

    test('emits [AuthorLoading, AuthorError] when getHomeFeed fails', () async {
      fakeRepo.shouldSucceed = false;
      fakeRepo.errorMessage = 'Network connection failed';

      final expectedStates = [
        const AuthorLoading(),
        const AuthorError('Network connection failed'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAuthorArticles('Wade Warren');
    });
  });
}
