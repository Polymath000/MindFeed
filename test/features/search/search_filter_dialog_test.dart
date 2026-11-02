import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_tag_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/search/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/search_articles_use_case.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';

class _FakeSearchArticlesRepo extends Fake implements ArticlesRepository {
  static const catTech = CategoryEntity(
    id: 'cat_tech',
    name: 'Technology',
    slug: 'technology',
  );
  static const catScience = CategoryEntity(
    id: 'cat_sci',
    name: 'Science',
    slug: 'science',
  );
  static const tagFlutter = TagEntity(
    id: 'tag_flutter',
    name: 'flutter',
    slug: 'flutter',
  );
  static const tagAi = TagEntity(
    id: 'tag_ai',
    name: 'ai',
    slug: 'ai',
  );

  static const articleFlutter = ArticleEntity(
    id: 'art_flutter',
    title: 'Flutter Editorial Guide',
    slug: 'flutter-editorial-guide',
    excerpt: 'Clean widget composition and state.',
    badge: 'TECH',
    categoryId: 'cat_tech',
    categorySlug: 'technology',
    tags: ['flutter'],
  );

  static const articleAi = ArticleEntity(
    id: 'art_ai',
    title: 'AI Systems Overview',
    slug: 'ai-systems-overview',
    excerpt: 'Reasoning models in production.',
    badge: 'TECH',
    categoryId: 'cat_tech',
    categorySlug: 'technology',
    tags: ['ai'],
  );

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async =>
      const Success([catTech, catScience]);

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async =>
      const Success([tagFlutter, tagAi]);

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (categoryId == 'cat_tech') {
      return const Success([articleFlutter, articleAi]);
    }
    return const Success([]);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (tag == 'flutter') return const Success([articleFlutter]);
    if (tag == 'ai') return const Success([articleAi]);
    return const Success([]);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async =>
      const Success([articleFlutter, articleAi]);

  @override
  Future<ApiResult<String>> uploadArticleCoverImage({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousCoverUrl,
  }) async =>
      const Success('https://example.com/cover.jpg');
}

void main() {
  testWidgets(
    'SearchView hides full categories/tags lists inline and lets user pick filters from EditorialFilterDialog',
    (tester) async {
      final repo = _FakeSearchArticlesRepo();
      final cubit = SearchCubit(
        searchArticlesUseCase: SearchArticlesUseCase(repo),
        getArticlesByCategoryUseCase: GetArticlesByCategoryUseCase(repo),
        getCategoriesUseCase: GetCategoriesUseCase(repo),
        getFixedTagsUseCase: GetFixedTagsUseCase(repo),
        getArticlesByTagUseCase: GetArticlesByTagUseCase(repo),
      );
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: SearchView(cubit: cubit)),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Unselected categories & tags are NOT dumped inline on SearchView
      expect(find.text('Technology'), findsNothing);
      expect(find.text('Science'), findsNothing);
      expect(find.text('#flutter'), findsNothing);
      expect(find.text('#ai'), findsNothing);
      expect(
        find.byKey(const ValueKey('search_filter_dialog_button')),
        findsOneWidget,
      );

      // 2. Open the Filter Dialog
      await tester.tap(
        find.byKey(const ValueKey('search_filter_dialog_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Filter Stories'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Filter by tags'), findsOneWidget);
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Science'), findsOneWidget);
      expect(find.text('#flutter'), findsOneWidget);
      expect(find.text('#ai'), findsOneWidget);

      // 3. Choose Technology category + #flutter tag and apply
      await tester.tap(find.text('Technology'));
      await tester.pump();
      await tester.tap(find.text('#flutter'));
      await tester.pump();

      expect(find.text('Apply Filters (2)'), findsOneWidget);
      await tester.tap(find.text('Apply Filters (2)'));
      await tester.pumpAndSettle();

      // 4. Dialog closes; ONLY chosen filters & matching article appear on SearchView
      expect(find.text('Filter Stories'), findsNothing);
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('#flutter'), findsOneWidget);
      expect(find.text('Science'), findsNothing);
      expect(find.text('#ai'), findsNothing);
      expect(find.text('Flutter Editorial Guide'), findsOneWidget);
      expect(find.text('AI Systems Overview'), findsNothing);

      // 5. Clear all resets active chips and returns to initial prompt
      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();

      expect(find.text('Technology'), findsNothing);
      expect(find.text('#flutter'), findsNothing);
      expect(
        find.text(
          'Search for stories or tap Filter to choose categories and tags.',
        ),
        findsOneWidget,
      );
    },
  );
}
