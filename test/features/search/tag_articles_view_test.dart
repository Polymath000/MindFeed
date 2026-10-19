import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_tag_use_case.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_cubit.dart';
import 'package:mind_feed/features/search/presentation/views/tag_articles_view.dart';
import '../author/fake_author_articles_repository.dart';

void main() {
  late FakeAuthorArticlesRepository fakeRepo;
  late GetArticlesByTagUseCase getArticlesByTagUseCase;

  const sampleTagArticle = ArticleEntity(
    id: 'flutter-article-1',
    title: 'Deep Dive into Flutter',
    slug: 'deep-dive-flutter',
    excerpt: 'Detailed flutter article.',
    tags: ['flutter'],
  );

  setUp(() {
    fakeRepo = FakeAuthorArticlesRepository();
    getArticlesByTagUseCase = GetArticlesByTagUseCase(fakeRepo);
  });

  Widget buildTestWidget(TagArticlesCubit cubit, {String tag = 'flutter'}) {
    return MaterialApp(
      home: TagArticlesView(cubit: cubit, tag: tag),
    );
  }

  testWidgets('renders tag title in app bar and articles when cubit loads', (tester) async {
    fakeRepo.feedArticles = [sampleTagArticle];
    final cubit = TagArticlesCubit(getArticlesByTagUseCase: getArticlesByTagUseCase);

    await tester.pumpWidget(buildTestWidget(cubit, tag: 'flutter'));
    await cubit.loadArticlesByTag('flutter');
    await tester.pumpAndSettle();

    expect(find.text('#flutter'), findsOneWidget);
    expect(find.text('Deep Dive into Flutter'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders empty message when no articles match tag', (tester) async {
    fakeRepo.feedArticles = [];
    final cubit = TagArticlesCubit(getArticlesByTagUseCase: getArticlesByTagUseCase);

    await tester.pumpWidget(buildTestWidget(cubit, tag: 'unknown'));
    await cubit.loadArticlesByTag('unknown');
    await tester.pumpAndSettle();

    expect(find.text('No articles found with #unknown'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders error message when query fails', (tester) async {
    fakeRepo.shouldSucceed = false;
    fakeRepo.errorMessage = 'Network timeout';
    final cubit = TagArticlesCubit(getArticlesByTagUseCase: getArticlesByTagUseCase);

    await tester.pumpWidget(buildTestWidget(cubit, tag: 'flutter'));
    await cubit.loadArticlesByTag('flutter');
    await tester.pumpAndSettle();

    expect(find.text('Network timeout'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await cubit.close();
  });
}
