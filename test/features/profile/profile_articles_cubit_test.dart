import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';
import 'fake_articles_repository.dart';

void main() {
  late FakeArticlesRepository fakeRepo;
  late DeleteArticleUseCase deleteUseCase;
  late ProfileArticlesCubit cubit;

  final samplePublished = ArticleEntity(
    id: 'pub-1',
    title: 'Published Article',
    slug: 'published-article',
    excerpt: 'Published excerpt',
    status: 'published',
    publishedAt: DateTime.now().subtract(const Duration(days: 5)),
  );

  final sampleDraft = ArticleEntity(
    id: 'draft-1',
    title: 'Draft Article',
    slug: 'draft-article',
    excerpt: 'Draft excerpt',
    status: 'draft',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  );

  setUp(() {
    fakeRepo = FakeArticlesRepository();
    deleteUseCase = DeleteArticleUseCase(fakeRepo);
    cubit = ProfileArticlesCubit(
      articlesRepository: fakeRepo,
      deleteArticleUseCase: deleteUseCase,
      userId: 'test-author',
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ProfileArticlesCubit load', () {
    test('initial state is ProfileArticlesInitial', () {
      expect(cubit.state, equals(const ProfileArticlesInitial()));
    });

    test('emits [ProfileArticlesLoading, ProfileArticlesLoaded] with accurate counts on success', () async {
      fakeRepo.authorArticles = [samplePublished, sampleDraft];

      final expectedStates = [
        const ProfileArticlesLoading(),
        isA<ProfileArticlesLoaded>()
            .having((s) => s.articles.length, 'length', 2)
            .having((s) => s.publishedCount, 'publishedCount', 1)
            .having((s) => s.draftCount, 'draftCount', 1),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadArticles();

      expect(cubit.articles.length, 2);
    });

    test('emits [ProfileArticlesLoading, ProfileArticlesEmpty] when author has no articles', () async {
      fakeRepo.authorArticles = [];

      final expectedStates = [
        const ProfileArticlesLoading(),
        const ProfileArticlesEmpty(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadArticles();

      expect(cubit.articles, isEmpty);
    });

    test('emits [ProfileArticlesLoading, ProfileArticlesError] on repo failure', () async {
      fakeRepo.shouldLoadSucceed = false;
      fakeRepo.failureMessage = 'Database connection lost';

      final expectedStates = [
        const ProfileArticlesLoading(),
        const ProfileArticlesError('Database connection lost'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadArticles();
    });

    test('emits ProfileArticlesEmpty when target user id is missing', () async {
      final unauthenticatedCubit = ProfileArticlesCubit(
        articlesRepository: fakeRepo,
        deleteArticleUseCase: deleteUseCase,
        userId: null,
      );

      await unauthenticatedCubit.loadArticles();

      expect(unauthenticatedCubit.state, equals(const ProfileArticlesEmpty()));
      await unauthenticatedCubit.close();
    });
  });

  group('ProfileArticlesCubit deleteArticle', () {
    test('delete success removes target article from state and returns true', () async {
      fakeRepo.authorArticles = [samplePublished, sampleDraft];
      await cubit.loadArticles();

      expect(cubit.articles.length, 2);

      final success = await cubit.deleteArticle(samplePublished.id);

      expect(success, isTrue);
      expect(cubit.articles.length, 1);
      expect(cubit.articles.first.id, 'draft-1');
      expect(cubit.state, isA<ProfileArticlesLoaded>());
      final loaded = cubit.state as ProfileArticlesLoaded;
      expect(loaded.articles.length, 1);
      expect(loaded.publishedCount, 0);
      expect(loaded.draftCount, 1);
    });

    test('delete success on last article transitions state to ProfileArticlesEmpty', () async {
      fakeRepo.authorArticles = [samplePublished];
      await cubit.loadArticles();

      final success = await cubit.deleteArticle(samplePublished.id);

      expect(success, isTrue);
      expect(cubit.articles, isEmpty);
      expect(cubit.state, equals(const ProfileArticlesEmpty()));
    });

    test('delete failure keeps article in state and returns false', () async {
      fakeRepo.authorArticles = [samplePublished, sampleDraft];
      await cubit.loadArticles();

      fakeRepo.shouldDeleteSucceed = false;
      fakeRepo.failureMessage = 'Delete denied by server trigger';

      final success = await cubit.deleteArticle(samplePublished.id);

      expect(success, isFalse);
      expect(cubit.articles.length, 2);
      expect(cubit.state, isA<ProfileArticlesLoaded>());
      final loaded = cubit.state as ProfileArticlesLoaded;
      expect(loaded.articles.any((a) => a.id == samplePublished.id), isTrue);
    });
  });
}
