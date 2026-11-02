import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/author/presentation/views/author_view.dart';
import 'package:mind_feed/features/author/presentation/widgets/article_card_of_author.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_status_views.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';

class _DelayedArticlesRepo extends Fake implements ArticlesRepository {
  _DelayedArticlesRepo(this.completer);

  final Completer<ApiResult<List<ArticleEntity>>> completer;

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) =>
      completer.future;
}

void main() {
  testWidgets(
    'AuthorView renders Skeletonizer on dossier header and stories list while loading and transitions to loaded content',
    (tester) async {
      final completer = Completer<ApiResult<List<ArticleEntity>>>();
      final repo = _DelayedArticlesRepo(completer);
      final cubit = AuthorCubit(
        getHomeFeedUseCase: GetHomeFeedUseCase(repo),
      );
      addTearDown(cubit.close);

      unawaited(cubit.loadAuthorArticles('Dr. Elena Rostova'));

      await tester.pumpWidget(
        MaterialApp(
          home: AuthorView(
            cubit: cubit,
            authorName: 'Dr. Elena Rostova',
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AuthorLoadingView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ArticleCardOfAuthor), findsNWidgets(3));

      final skeletonFinder = find.byWidgetPredicate((w) => w is Skeletonizer);
      expect(skeletonFinder, findsWidgets);

      final skeletonWidgets =
          tester.widgetList<Skeletonizer>(skeletonFinder).toList();
      expect(skeletonWidgets.isNotEmpty, isTrue);
      expect(skeletonWidgets.every((s) => s.enabled), isTrue);

      completer.complete(
        const Success([
          ArticleEntity(
            id: 'elena_1',
            title: 'Room Temperature Quantum Coherence',
            slug: 'quantum-coherence',
            excerpt: 'Breakthrough physics.',
            authorName: 'Dr. Elena Rostova',
            status: 'published',
            badge: 'SCIENCE',
          ),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(AuthorLoadingView), findsNothing);
      expect(find.text('Room Temperature Quantum Coherence'), findsOneWidget);

      final postLoadSkeletons =
          tester.widgetList<Skeletonizer>(skeletonFinder).toList();
      expect(postLoadSkeletons.isNotEmpty, isTrue);
      expect(postLoadSkeletons.every((s) => !s.enabled), isTrue);
    },
  );
}
