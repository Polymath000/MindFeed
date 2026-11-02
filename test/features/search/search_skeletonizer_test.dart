import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_tag_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/core/design/editorial_card.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/search/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/search_articles_use_case.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_cubit.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';
import 'package:mind_feed/features/search/presentation/views/tag_articles_view.dart';
import 'package:mind_feed/features/search/presentation/widgets/search_results_view.dart';

class _DelayedArticlesRepo implements ArticlesRepository {
  _DelayedArticlesRepo(this.completer);

  final Completer<ApiResult<List<ArticleEntity>>> completer;

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async => const Success([
        CategoryEntity(id: 'cat_tech', name: 'Technology', slug: 'technology'),
      ]);

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async => const Success([
        TagEntity(id: 'tag_ai', name: 'AI', slug: 'ai'),
      ]);

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) => completer.future;

  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) => completer.future;

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) => completer.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'SearchView renders Skeletonizer in SearchLoadingView while loading and switches to content on success',
    (tester) async {
      final completer = Completer<ApiResult<List<ArticleEntity>>>();
      final repo = _DelayedArticlesRepo(completer);
      final cubit = SearchCubit(
        searchArticlesUseCase: SearchArticlesUseCase(repo),
        getArticlesByCategoryUseCase: GetArticlesByCategoryUseCase(repo),
        getCategoriesUseCase: GetCategoriesUseCase(repo),
        getFixedTagsUseCase: GetFixedTagsUseCase(repo),
        getArticlesByTagUseCase: GetArticlesByTagUseCase(repo),
      );
      addTearDown(cubit.close);
      await cubit.loadInitialFilters();

      unawaited(
        cubit.selectCategory(
          const CategoryEntity(
            id: 'cat_tech',
            name: 'Technology',
            slug: 'technology',
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: SearchView(cubit: cubit)),
        ),
      );
      await tester.pump();

      expect(find.byType(SearchLoadingView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(EditorialCard), findsNWidgets(3));

      final skeletonFinder = find.descendant(
        of: find.byType(SearchLoadingView),
        matching: find.byWidgetPredicate((w) => w is Skeletonizer),
      );
      expect(skeletonFinder, findsOneWidget);
      final skeletonizer = tester.widget<Skeletonizer>(skeletonFinder);
      expect(skeletonizer.enabled, isTrue);

      completer.complete(
        const Success([
          ArticleEntity(
            id: 'art_1',
            title: 'Quantum Search Architecture',
            slug: 'quantum-search',
            excerpt: 'Fast indexing.',
            badge: 'TECH',
          ),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(SearchLoadingView), findsNothing);
      expect(find.text('Quantum Search Architecture'), findsOneWidget);
    },
  );

  testWidgets(
    'TagArticlesView renders Skeletonizer in SearchLoadingView while loading and switches to content on success',
    (tester) async {
      final completer = Completer<ApiResult<List<ArticleEntity>>>();
      final repo = _DelayedArticlesRepo(completer);
      final cubit = TagArticlesCubit(
        getArticlesByTagUseCase: GetArticlesByTagUseCase(repo),
      );
      addTearDown(cubit.close);

      unawaited(cubit.loadArticlesByTag('tech'));

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: TagArticlesView(cubit: cubit, tag: 'tech'),
        ),
      );
      await tester.pump();

      expect(find.byType(SearchLoadingView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(EditorialCard), findsNWidgets(3));

      final skeletonFinder = find.descendant(
        of: find.byType(SearchLoadingView),
        matching: find.byWidgetPredicate((w) => w is Skeletonizer),
      );
      expect(skeletonFinder, findsOneWidget);
      final skeletonizer = tester.widget<Skeletonizer>(skeletonFinder);
      expect(skeletonizer.enabled, isTrue);

      completer.complete(
        const Success([
          ArticleEntity(
            id: 'art_1',
            title: 'Quantum Search Architecture',
            slug: 'quantum-search',
            excerpt: 'Fast indexing.',
            badge: 'TECH',
          ),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(SearchLoadingView), findsNothing);
      expect(find.text('Quantum Search Architecture'), findsOneWidget);
    },
  );
}
