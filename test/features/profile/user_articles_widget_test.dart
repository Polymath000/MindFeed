import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/widgets/user_articles.dart';
import 'fake_articles_repository.dart';

void main() {
  late FakeArticlesRepository fakeRepo;
  late GetArticlesByAuthorUseCase getArticlesByAuthorUseCase;
  late DeleteArticleUseCase deleteUseCase;

  final publishedItem1 = ArticleEntity(
    id: 'pub-1',
    title: 'First Story',
    slug: 'first-story',
    excerpt: 'Excerpt 1',
    status: 'published',
    publishedAt: DateTime.now().subtract(const Duration(days: 2)),
  );

  final publishedItem2 = ArticleEntity(
    id: 'pub-2',
    title: 'Second Story',
    slug: 'second-story',
    excerpt: 'Excerpt 2',
    status: 'published',
    publishedAt: DateTime.now().subtract(const Duration(days: 4)),
  );

  final draftItem1 = ArticleEntity(
    id: 'draft-1',
    title: 'Working Title Draft',
    slug: 'draft-title',
    excerpt: 'Draft excerpt',
    status: 'draft',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  );

  setUp(() {
    fakeRepo = FakeArticlesRepository();
    getArticlesByAuthorUseCase = GetArticlesByAuthorUseCase(fakeRepo);
    deleteUseCase = DeleteArticleUseCase(fakeRepo);
  });

  Widget buildTestWidget(ProfileArticlesCubit cubit) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            UserArticles(cubit: cubit),
          ],
        ),
      ),
    );
  }

  testWidgets('renders accurate published and draft count badge for mixed articles', (tester) async {
    fakeRepo.authorArticles = [publishedItem1, publishedItem2, draftItem1];
    final cubit = ProfileArticlesCubit(
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      deleteArticleUseCase: deleteUseCase,
      userId: 'author-123',
    );

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadArticles();
    await tester.pumpAndSettle();

    expect(find.text('2 published · 1 draft'), findsOneWidget);
    expect(find.text('3 published'), findsNothing);
    expect(find.text('First Story'), findsOneWidget);
    expect(find.text('Second Story'), findsOneWidget);
    expect(find.text('Working Title Draft'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders empty placeholder when no articles exist', (tester) async {
    fakeRepo.authorArticles = [];
    final cubit = ProfileArticlesCubit(
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      deleteArticleUseCase: deleteUseCase,
      userId: 'author-123',
    );

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadArticles();
    await tester.pumpAndSettle();

    expect(find.text('No published articles yet'), findsOneWidget);
    expect(find.text('0 published'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('delete button prompts confirmation dialog and removes on confirm', (tester) async {
    fakeRepo.authorArticles = [publishedItem1];
    final cubit = ProfileArticlesCubit(
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      deleteArticleUseCase: deleteUseCase,
      userId: 'author-123',
    );

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadArticles();
    await tester.pumpAndSettle();

    expect(find.byIcon(AppIcons.delete), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pumpAndSettle();

    expect(find.text('Delete Article'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('First Story'), findsOneWidget);
    expect(cubit.articles.length, 1);

    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(cubit.articles, isEmpty);
    expect(find.text('Removed: First Story'), findsOneWidget);
    expect(find.text('No published articles yet'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('delete failure keeps item and shows error snackbar', (tester) async {
    fakeRepo.authorArticles = [publishedItem1];
    fakeRepo.shouldDeleteSucceed = false;
    final cubit = ProfileArticlesCubit(
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
      deleteArticleUseCase: deleteUseCase,
      userId: 'author-123',
    );

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadArticles();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(cubit.articles.length, 1);
    expect(find.text('First Story'), findsOneWidget);
    expect(find.text('Failed to delete article. Please try again.'), findsOneWidget);

    await cubit.close();
  });
}
