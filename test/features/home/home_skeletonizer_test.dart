import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/design/editorial_card_stack.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/presentation/controllers/home_feed/home_feed_cubit.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_view_body.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_feed_loading_views.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_user_feed_topics_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_lead_story_section.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_masthead_header.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class _DelayedArticlesRepo implements ArticlesRepository, ArticleEngagementRepository {
  _DelayedArticlesRepo(this.completer);

  final Completer<ApiResult<List<ArticleEntity>>> completer;

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) => completer.future;

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async =>
      const Success([]);

  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<bool>> isArticleLiked(String articleId, String userId) async =>
      const Success(false);

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> removeBookmark(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async =>
      const Success(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProfileRepo implements ProfileRepository {
  _FakeProfileRepo(this.favorites);

  final List<Map<String, dynamic>> favorites;

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(
    String userId,
  ) async => Success(favorites);

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getCategories() async =>
      const Success([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'HomeViewBody renders Skeletonizer in HomeFeedLoadingView while loading and switches to content on success',
    (tester) async {
      final completer = Completer<ApiResult<List<ArticleEntity>>>();
      final repo = _DelayedArticlesRepo(completer);
      final profileRepo = _FakeProfileRepo([
        {'name': 'Neuroscience', 'category_name': 'Neuroscience'},
        {'name': 'Philosophy', 'category_name': 'Philosophy'},
      ]);
      final cubit = HomeFeedCubit(
        getHomeFeedUseCase: GetHomeFeedUseCase(repo),
        getUserFeedTopicsUseCase: GetUserFeedTopicsUseCase(profileRepository: profileRepo),
        getSavedArticlesUseCase: GetSavedArticlesUseCase(repo),
        toggleBookmarkUseCase: ToggleBookmarkUseCase(repo),
        toggleStarUseCase: ToggleStarUseCase(repo),
        toggleArticleLikeUseCase: ToggleArticleLikeUseCase(repo),
        currentUserId: 'user_1',
      )..fetchFeed();
      addTearDown(cubit.close);

      await tester.pumpWidget(MaterialApp(home: HomeViewBody(cubit: cubit)));
      await tester.pump();

      final skeletonFinder = find.byWidgetPredicate((w) => w is Skeletonizer);
      expect(find.byType(HomeFeedLoadingView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(skeletonFinder, findsWidgets);
      expect(find.byType(EditorialCardStack), findsOneWidget);
      expect(find.byType(HomeSecondaryStoryTile), findsNWidgets(3));

      final skeletonWidgets = tester
          .widgetList<Skeletonizer>(skeletonFinder)
          .toList();
      expect(skeletonWidgets.every((s) => s.enabled), isTrue);

      completer.complete(
        const Success([
          ArticleEntity(
            id: 'art_loaded_1',
            title: 'Loaded Editorial Headline',
            slug: 'loaded-editorial-headline',
            excerpt: 'Loaded editorial excerpt.',
            badge: 'TECH',
            tags: ['Tech'],
          ),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(HomeFeedLoadingView), findsNothing);
      expect(find.text('Loaded Editorial Headline'), findsWidgets);

      final tabsBar = tester.widget<HomeTopicTabsBar>(
        find.byType(HomeTopicTabsBar),
      );
      expect(tabsBar.topics, equals(['All', 'Neuroscience', 'Philosophy']));
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Neuroscience'), findsOneWidget);
      expect(find.text('Philosophy'), findsOneWidget);

      final postLoadSkeletons = tester
          .widgetList<Skeletonizer>(skeletonFinder)
          .toList();
      expect(postLoadSkeletons.every((s) => !s.enabled), isTrue);
    },
  );
}
