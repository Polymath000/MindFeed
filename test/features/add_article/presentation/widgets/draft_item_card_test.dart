import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/routes/add_article_routes.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/draft_item_card.dart';
import '../controllers/add_article_cubit_test.dart';

void main() {
  late FakeArticlesRepository repo;
  late DraftsCubit cubit;

  const testUser = CurrentUserSnapshot(
    id: 'author-test',
    displayName: 'Test Author',
    email: 'test@mindfeed.com',
  );

  final testDraft = EditorialNewsItem(
    id: 'draft-42',
    badge: 'TECH',
    badgeColor: AppColors.ink,
    title: 'The Future of Quantum Computing',
    updated: '2 hours ago',
    authorName: 'Ada Lovelace',
    authorRole: 'Contributor',
    authorAvatar: '',
    excerpt: 'Exploring quantum computing principles and draft ideas.',
    color: AppColors.cream,
    content: 'Draft content body here...',
    status: 'draft',
    readingTimeMinutes: 4,
  );

  setUp(() {
    repo = FakeArticlesRepository();
    repo.articles[testDraft.id] = ArticleEntity(
      id: testDraft.id,
      title: testDraft.title,
      slug: 'quantum-computing',
      excerpt: testDraft.excerpt,
      authorId: testUser.id,
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    cubit = DraftsCubit(
      getArticlesByAuthorUseCase: GetArticlesByAuthorUseCase(repo),
      deleteArticleUseCase: DeleteArticleUseCase(repo),
      userResolver: () => testUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  Widget buildTestHarness({
    required Widget child,
    void Function(Object? arg)? onAddArticleNavigated,
    void Function(Object? arg)? onPreviewNavigated,
  }) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider<DraftsCubit>.value(
          value: cubit,
          child: Scaffold(body: child),
        ),
        AddArticleRoutes.addArticle: (context) {
          final arg = ModalRoute.of(context)?.settings.arguments;
          onAddArticleNavigated?.call(arg);
          return const Scaffold(body: Text('Add Article Target'));
        },
        AddArticleRoutes.articlePreview: (context) {
          final arg = ModalRoute.of(context)?.settings.arguments;
          onPreviewNavigated?.call(arg);
          return const Scaffold(body: Text('Article Preview Target'));
        },
      },
    );
  }

  testWidgets('renders draft details and metadata correctly', (tester) async {
    await tester.pumpWidget(
      buildTestHarness(child: DraftItemCard(draft: testDraft)),
    );

    expect(find.text('The Future of Quantum Computing'), findsOneWidget);
    expect(find.text('DRAFT'), findsOneWidget);
    expect(find.text('2 hours ago'), findsOneWidget);
    expect(find.text('4 min read'), findsOneWidget);
    expect(find.byKey(Key('draft_card_${testDraft.id}')), findsOneWidget);
    expect(
      find.byKey(Key('publish_draft_button_${testDraft.id}')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('edit_draft_button_${testDraft.id}')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('preview_draft_button_${testDraft.id}')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('delete_draft_button_${testDraft.id}')),
      findsOneWidget,
    );
  });

  testWidgets('tapping card body opens draft in editor', (tester) async {
    Object? navigatedArg;
    await tester.pumpWidget(
      buildTestHarness(
        child: DraftItemCard(draft: testDraft),
        onAddArticleNavigated: (arg) => navigatedArg = arg,
      ),
    );

    await tester.tap(find.byKey(Key('draft_card_${testDraft.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Add Article Target'), findsOneWidget);
    expect(navigatedArg, testDraft);
  });

  testWidgets('tapping Publish button opens draft in editor to publish', (
    tester,
  ) async {
    Object? navigatedArg;
    await tester.pumpWidget(
      buildTestHarness(
        child: DraftItemCard(draft: testDraft),
        onAddArticleNavigated: (arg) => navigatedArg = arg,
      ),
    );

    await tester.tap(find.byKey(Key('publish_draft_button_${testDraft.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Add Article Target'), findsOneWidget);
    expect(navigatedArg, testDraft);
  });

  testWidgets('tapping Edit button opens draft in editor', (tester) async {
    Object? navigatedArg;
    await tester.pumpWidget(
      buildTestHarness(
        child: DraftItemCard(draft: testDraft),
        onAddArticleNavigated: (arg) => navigatedArg = arg,
      ),
    );

    await tester.tap(find.byKey(Key('edit_draft_button_${testDraft.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Add Article Target'), findsOneWidget);
    expect(navigatedArg, testDraft);
  });

  testWidgets('tapping Preview button navigates to preview view', (
    tester,
  ) async {
    Object? navigatedArg;
    await tester.pumpWidget(
      buildTestHarness(
        child: DraftItemCard(draft: testDraft),
        onPreviewNavigated: (arg) => navigatedArg = arg,
      ),
    );

    await tester.tap(find.byKey(Key('preview_draft_button_${testDraft.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Article Preview Target'), findsOneWidget);
    expect(navigatedArg, testDraft);
  });

  testWidgets('confirming delete dialog deletes the draft', (tester) async {
    await tester.pumpWidget(
      buildTestHarness(child: DraftItemCard(draft: testDraft)),
    );

    await tester.tap(find.byKey(Key('delete_draft_button_${testDraft.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Delete Draft?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repo.articles.containsKey(testDraft.id), isFalse);
  });
}
