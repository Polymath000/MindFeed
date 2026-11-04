import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/design/editorial_saved_stack.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/collections/presentation/controllers/collections_cubit.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/collections/presentation/widgets/saved_articles_loading_view.dart';

class _DelayedArticlesRepo implements ArticlesRepository, ArticleEngagementRepository {
  _DelayedArticlesRepo(this.completer);

  final Completer<ApiResult<List<ArticleEntity>>> completer;

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) =>
      completer.future;

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> removeBookmark(String articleId, String userId) async =>
      const Success(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'ArticlesSaved renders Skeletonizer in SavedArticlesLoadingView while loading and switches to content on success',
    (tester) async {
      final completer = Completer<ApiResult<List<ArticleEntity>>>();
      final repo = _DelayedArticlesRepo(completer);
      final cubit = CollectionsCubit(
        getSavedArticlesUseCase: GetSavedArticlesUseCase(repo),
        toggleBookmarkUseCase: ToggleBookmarkUseCase(repo),
        currentUserId: 'user_1',
      );
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticlesSaved(cubit: cubit),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SavedArticlesLoadingView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(EditorialSavedStack), findsOneWidget);

      final skeletonFinder = find.byWidgetPredicate((w) => w is Skeletonizer);
      expect(skeletonFinder, findsOneWidget);
      final skeletonizer = tester.widget<Skeletonizer>(skeletonFinder);
      expect(skeletonizer.enabled, isTrue);

      completer.complete(
        const Success([
          ArticleEntity(
            id: 'saved_1',
            title: 'Saved Editorial Deep Dive',
            slug: 'saved-deep-dive',
            excerpt: 'Saved excerpt body.',
          ),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(SavedArticlesLoadingView), findsNothing);
      expect(find.text('Saved Editorial Deep Dive'), findsOneWidget);
    },
  );
}
