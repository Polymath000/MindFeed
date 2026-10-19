import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_tag_use_case.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_cubit.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_state.dart';
import '../author/fake_author_articles_repository.dart';

void main() {
  late FakeAuthorArticlesRepository fakeRepo;
  late GetArticlesByTagUseCase getArticlesByTagUseCase;
  late TagArticlesCubit cubit;

  const flutterArticle = ArticleEntity(
    id: 'tag-1',
    title: 'Flutter in 2026',
    slug: 'flutter-2026',
    excerpt: 'State of Flutter',
    tags: ['flutter', 'mobile'],
  );

  const dartArticle = ArticleEntity(
    id: 'tag-2',
    title: 'Dart Patterns',
    slug: 'dart-patterns',
    excerpt: 'Pattern matching in Dart',
    tags: ['dart'],
  );

  setUp(() {
    fakeRepo = FakeAuthorArticlesRepository();
    getArticlesByTagUseCase = GetArticlesByTagUseCase(fakeRepo);
    cubit = TagArticlesCubit(getArticlesByTagUseCase: getArticlesByTagUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('TagArticlesCubit', () {
    test('initial state is TagArticlesInitial', () {
      expect(cubit.state, equals(const TagArticlesInitial()));
    });

    test('emits [TagArticlesLoading, TagArticlesLoaded] with matching tagged articles', () async {
      fakeRepo.feedArticles = [flutterArticle, dartArticle];

      final expectedStates = [
        const TagArticlesLoading(),
        isA<TagArticlesLoaded>()
            .having((s) => s.articles.length, 'length', 1)
            .having((s) => s.articles.first.id, 'id', 'tag-1'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadArticlesByTag('flutter');
    });

    test('emits [TagArticlesLoading, TagArticlesEmpty] when no articles match tag', () async {
      fakeRepo.feedArticles = [dartArticle];

      final expectedStates = [
        const TagArticlesLoading(),
        const TagArticlesEmpty(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadArticlesByTag('react');
    });

    test('emits [TagArticlesLoading, TagArticlesError] when repository fails', () async {
      fakeRepo.shouldSucceed = false;
      fakeRepo.errorMessage = 'Database query failed';

      final expectedStates = [
        const TagArticlesLoading(),
        const TagArticlesError('Database query failed'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadArticlesByTag('flutter');
    });
  });
}
