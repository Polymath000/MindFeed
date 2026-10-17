import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_state.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_article_use_case.dart';
import 'add_article_cubit_test.dart';

void main() {
  late FakeArticlesRepository repo;
  late DraftsCubit cubit;

  const testUser = CurrentUserSnapshot(
    id: 'author-99',
    displayName: 'Draft Author',
    email: 'draft@mindfeed.com',
  );

  setUp(() {
    repo = FakeArticlesRepository();
    cubit = DraftsCubit(
      articlesRepository: repo,
      deleteArticleUseCase: DeleteArticleUseCase(repo),
      userResolver: () => testUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('loadDrafts emits DraftsEmpty when user has no drafts', () async {
    await cubit.loadDrafts();
    expect(cubit.state, isA<DraftsEmpty>());
  });

  test('loadDrafts filters and emits DraftsLoaded with only drafts', () async {
    final draftArticle = ArticleEntity(
      id: 'd-1',
      title: 'First Draft',
      slug: 'first-draft',
      excerpt: 'Excerpt',
      authorId: testUser.id,
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final publishedArticle = ArticleEntity(
      id: 'p-1',
      title: 'Published Story',
      slug: 'published-story',
      excerpt: 'Excerpt',
      authorId: testUser.id,
      status: 'published',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    repo.articles[draftArticle.id] = draftArticle;
    repo.articles[publishedArticle.id] = publishedArticle;

    await cubit.loadDrafts();

    expect(cubit.state, isA<DraftsLoaded>());
    final loadedState = cubit.state as DraftsLoaded;
    expect(loadedState.drafts.length, 1);
    expect(loadedState.drafts.first.id, 'd-1');
  });

  test('loadDrafts emits DraftsError when user is null', () async {
    final unauthCubit = DraftsCubit(
      articlesRepository: repo,
      deleteArticleUseCase: DeleteArticleUseCase(repo),
      userResolver: () => null,
    );

    await unauthCubit.loadDrafts();
    expect(unauthCubit.state, isA<DraftsError>());
    final errState = unauthCubit.state as DraftsError;
    expect(errState.message, 'User not authenticated');
    unauthCubit.close();
  });

  test('deleteDraft removes draft and reloads', () async {
    final draftArticle = ArticleEntity(
      id: 'd-2',
      title: 'To Delete',
      slug: 'to-delete',
      excerpt: 'Excerpt',
      authorId: testUser.id,
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    repo.articles[draftArticle.id] = draftArticle;

    await cubit.loadDrafts();
    expect(cubit.state, isA<DraftsLoaded>());

    await cubit.deleteDraft('d-2');

    expect(repo.articles.containsKey('d-2'), isFalse);
    expect(cubit.state, isA<DraftsEmpty>());
  });
}
