import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/views/profile_view.dart';
import 'package:mind_feed/features/profile/presentation/widgets/custom_article_card_of_profile.dart';
import 'package:mind_feed/features/profile/presentation/widgets/personal_infromation.dart';
import 'package:mind_feed/features/profile/presentation/widgets/profile_articles_status_views.dart';

class _DelayedProfileRepo extends Fake implements ProfileRepository {
  _DelayedProfileRepo(this.completer);

  final Completer<ApiResult<Map<String, dynamic>>> completer;

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) =>
      completer.future;

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(
    String userId,
  ) async =>
      const Success([]);
}

class _DelayedArticlesRepo extends Fake implements ArticlesRepository {
  _DelayedArticlesRepo(this.completer);

  final Completer<ApiResult<List<ArticleEntity>>> completer;

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) =>
      completer.future;

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async =>
      const Success(null);
}

void main() {
  testWidgets(
    'ProfileView renders Skeletonizer in PersonalInfromation and ProfileArticlesLoadingView while loading and switches to content on success',
    (tester) async {
      const validAuthorId = '11111111-2222-3333-4444-555555555555';
      final profileCompleter =
          Completer<ApiResult<Map<String, dynamic>>>();
      final articlesCompleter =
          Completer<ApiResult<List<ArticleEntity>>>();

      final profileRepo = _DelayedProfileRepo(profileCompleter);
      final articlesRepo = _DelayedArticlesRepo(articlesCompleter);

      final articlesCubit = ProfileArticlesCubit(
        getArticlesByAuthorUseCase: GetArticlesByAuthorUseCase(articlesRepo),
        deleteArticleUseCase: DeleteArticleUseCase(articlesRepo),
        userId: validAuthorId,
      )..loadArticles();

      final infoCubit = ProfileInfoCubit(
        getUserProfileUseCase: GetUserProfileUseCase(profileRepo),
        getFavoriteCategoriesUseCase: GetFavoriteCategoriesUseCase(profileRepo),
        getArticlesByAuthorUseCase: GetArticlesByAuthorUseCase(articlesRepo),
        userId: validAuthorId,
      )..loadProfileData(userId: validAuthorId);

      addTearDown(() {
        articlesCubit.close();
        infoCubit.close();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileView(
              cubit: articlesCubit,
              infoCubit: infoCubit,
            ),
          ),
        ),
      );
      await tester.pump();

      final skeletonFinder = find.byWidgetPredicate((w) => w is Skeletonizer);
      expect(find.byType(ProfileArticlesLoadingView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CustomArticleCardOfProfile), findsNWidgets(2));
      expect(skeletonFinder, findsWidgets);

      final enabledSkeletons = tester
          .widgetList<Skeletonizer>(skeletonFinder)
          .where((s) => s.enabled)
          .toList();
      expect(enabledSkeletons.length, greaterThanOrEqualTo(2));

      final personalInfoSkeletons = tester
          .widgetList<Skeletonizer>(
            find.descendant(
              of: find.byType(PersonalInfromation),
              matching: find.byWidgetPredicate((w) => w is Skeletonizer),
            ),
          )
          .toList();
      expect(personalInfoSkeletons.any((s) => s.enabled), isTrue);

      final articlesLoadingSkeletons = tester
          .widgetList<Skeletonizer>(
            find.descendant(
              of: find.byType(ProfileArticlesLoadingView),
              matching: find.byWidgetPredicate((w) => w is Skeletonizer),
            ),
          )
          .toList();
      expect(articlesLoadingSkeletons.any((s) => s.enabled), isTrue);

      profileCompleter.complete(
        const Success({
          'display_name': 'Grace Hopper',
          'bio': 'Pioneer of Computer Programming',
          'avatar_url': '',
        }),
      );
      articlesCompleter.complete(
        const Success([
          ArticleEntity(
            id: 'pub_1',
            title: 'Compiler Architecture Notes',
            slug: 'compiler-notes',
            excerpt: 'Compiler excerpt.',
            status: 'published',
          ),
        ]),
      );

      await tester.pump();
      await tester.pump();

      expect(find.byType(ProfileArticlesLoadingView), findsNothing);
      expect(find.text('Grace Hopper'), findsOneWidget);
      expect(find.text('Compiler Architecture Notes'), findsOneWidget);

      final postLoadSkeletons = tester
          .widgetList<Skeletonizer>(skeletonFinder)
          .toList();
      expect(postLoadSkeletons.every((s) => !s.enabled), isTrue);
    },
  );
}
