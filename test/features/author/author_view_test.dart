import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/author/presentation/views/author_view.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'fake_author_articles_repository.dart';

void main() {
  late FakeAuthorArticlesRepository fakeRepo;
  late GetHomeFeedUseCase getHomeFeedUseCase;

  const sampleAuthorArticle = ArticleEntity(
    id: 'wade-story-1',
    title: 'Future of Silicon Chips',
    slug: 'silicon-chips',
    excerpt: 'Detailed overview of next-gen silicon chips.',
    authorName: 'Wade Warren',
  );

  setUp(() {
    fakeRepo = FakeAuthorArticlesRepository();
    getHomeFeedUseCase = GetHomeFeedUseCase(fakeRepo);
  });

  Widget buildTestWidget(AuthorCubit cubit, {String authorName = 'Wade Warren', String? authorRole}) {
    return MaterialApp(
      home: AuthorView(
        cubit: cubit,
        authorName: authorName,
        authorRole: authorRole,
      ),
    );
  }

  testWidgets('renders author articles when cubit loads articles successfully', (tester) async {
    fakeRepo.feedArticles = [sampleAuthorArticle];
    final cubit = AuthorCubit(getHomeFeedUseCase: getHomeFeedUseCase);

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadAuthorArticles('Wade Warren');
    await tester.pumpAndSettle();

    expect(find.text('Wade Warren'), findsOneWidget);
    expect(find.text('Published Stories'), findsOneWidget);
    expect(find.text('1 stories'), findsOneWidget);
    expect(find.text('Future of Silicon Chips'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders 0 stories when author has no articles', (tester) async {
    fakeRepo.feedArticles = [];
    final cubit = AuthorCubit(getHomeFeedUseCase: getHomeFeedUseCase);

    await tester.pumpWidget(buildTestWidget(cubit));
    await cubit.loadAuthorArticles('Wade Warren');
    await tester.pumpAndSettle();

    expect(find.text('0 stories'), findsOneWidget);
    expect(find.text('Future of Silicon Chips'), findsNothing);

    await cubit.close();
  });

  testWidgets('renders dynamic author details properly', (tester) async {
    final cubit = AuthorCubit(getHomeFeedUseCase: getHomeFeedUseCase);

    await tester.pumpWidget(
      buildTestWidget(
        cubit,
        authorName: 'Ada Lovelace',
        authorRole: 'Chief Pioneer',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Chief Pioneer'), findsOneWidget);

    await cubit.close();
  });
}
