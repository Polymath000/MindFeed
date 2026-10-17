import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/data/models/article_model.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_article_like_use_case.dart';

class FakeArticleEngagementRepository implements ArticleEngagementRepository {
  bool shouldFail = false;
  final Set<String> likedArticles = {};
  AuthorRatingSummary currentSummary = const AuthorRatingSummary(
    authorKey: 'author-1',
    userStars: 0,
    ratingAvg: 0.0,
    ratingCount: 0,
  );

  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Network error'));
    }
    likedArticles.add('$userId:$articleId');
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Network error'));
    }
    likedArticles.remove('$userId:$articleId');
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> isArticleLiked(String articleId, String userId) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Network error'));
    }
    return Success(likedArticles.contains('$userId:$articleId'));
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Rating failed'));
    }
    currentSummary = AuthorRatingSummary(
      authorKey: authorKey,
      userStars: stars,
      ratingAvg: stars.toDouble(),
      ratingCount: 1,
    );
    return Success(currentSummary);
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (shouldFail) {
      return const FailureResult(ServerFailure('Summary failed'));
    }
    return Success(currentSummary);
  }
}

void main() {
  group('ArticleModel engagement and rating fields serialization', () {
    test('ArticleModel.fromJson parses likes_count and author rating values', () {
      final json = {
        'id': 'art-engagement-1',
        'title': 'Engagement Article',
        'slug': 'engagement-article',
        'excerpt': 'Testing metrics',
        'likes_count': 42,
        'author_rating_avg': 4.75,
        'author_rating_count': 120,
        'user_author_stars': 5,
      };

      final model = ArticleModel.fromJson(json);
      expect(model.likesCount, 42);
      expect(model.authorRatingAvg, 4.75);
      expect(model.authorRatingCount, 120);
      expect(model.userAuthorStars, 5);

      final editorial = model.toEditorialNewsItem();
      expect(editorial.likesCount, 42);
      expect(editorial.authorRatingAvg, 4.75);
      expect(editorial.authorRatingCount, 120);
      expect(editorial.userAuthorStars, 5);
    });

    test('ArticleModel.fromJson falls back to defaults when metrics are absent', () {
      final json = {
        'id': 'art-engagement-2',
        'title': 'Default Metrics',
        'slug': 'default-metrics',
        'excerpt': 'Testing nulls',
      };

      final model = ArticleModel.fromJson(json);
      expect(model.likesCount, 0);
      expect(model.authorRatingAvg, 0.0);
      expect(model.authorRatingCount, 0);
      expect(model.userAuthorStars, 0);
    });
  });

  group('EditorialNewsItem authorKey resolution', () {
    test('Returns authorId when present and non-empty', () {
      final item = EditorialNewsItem(
        id: '1',
        badge: 'TECH',
        badgeColor: const Color(0xFF000000),
        title: 'Title',
        updated: 'now',
        authorName: 'John Doe',
        authorRole: 'Editor',
        authorAvatar: '',
        excerpt: 'Excerpt',
        color: const Color(0xFFFFFFFF),
        authorId: 'auth-987',
      );

      expect(item.authorKey, 'auth-987');
    });

    test('Falls back to trimmed lowercase authorName when authorId is null', () {
      final item = EditorialNewsItem(
        id: '2',
        badge: 'TECH',
        badgeColor: const Color(0xFF000000),
        title: 'Title',
        updated: 'now',
        authorName: '  Jane Austin  ',
        authorRole: 'Editor',
        authorAvatar: '',
        excerpt: 'Excerpt',
        color: const Color(0xFFFFFFFF),
        authorId: null,
      );

      expect(item.authorKey, 'jane austin');
    });

    test('Falls back to authorName when authorId is whitespace only', () {
      final item = EditorialNewsItem(
        id: '3',
        badge: 'TECH',
        badgeColor: const Color(0xFF000000),
        title: 'Title',
        updated: 'now',
        authorName: 'Staff Reporter',
        authorRole: 'Editor',
        authorAvatar: '',
        excerpt: 'Excerpt',
        color: const Color(0xFFFFFFFF),
        authorId: '   ',
      );

      expect(item.authorKey, 'staff reporter');
    });
  });

  group('RateAuthorUseCase bounds and execution', () {
    late FakeArticleEngagementRepository repo;
    late RateAuthorUseCase rateUseCase;
    late GetAuthorRatingUseCase getUseCase;

    setUp(() {
      repo = FakeArticleEngagementRepository();
      rateUseCase = RateAuthorUseCase(repo);
      getUseCase = GetAuthorRatingUseCase(repo);
    });

    test('Fails when authorKey and authorId are both empty', () async {
      final result = await rateUseCase.call(
        authorKey: '  ',
        stars: 4,
        authorId: null,
      );

      result.when(
        success: (_) => fail('Expected failure for empty authorKey'),
        failure: (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'Author key is required');
        },
      );
    });

    test('Fails when stars < 1', () async {
      final result = await rateUseCase.call(
        authorKey: 'author-valid',
        stars: 0,
      );

      result.when(
        success: (_) => fail('Expected failure for stars < 1'),
        failure: (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'Author rating must be between 1 and 5 stars');
        },
      );
    });

    test('Fails when stars > 5', () async {
      final result = await rateUseCase.call(
        authorKey: 'author-valid',
        stars: 6,
      );

      result.when(
        success: (_) => fail('Expected failure for stars > 5'),
        failure: (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'Author rating must be between 1 and 5 stars');
        },
      );
    });

    test('Succeeds and returns summary when stars are between 1 and 5', () async {
      final result = await rateUseCase.call(
        authorKey: 'author-valid',
        stars: 5,
        authorName: 'Ada Lovelace',
      );

      result.when(
        success: (summary) {
          expect(summary.authorKey, 'author-valid');
          expect(summary.userStars, 5);
          expect(summary.ratingAvg, 5.0);
          expect(summary.ratingCount, 1);
        },
        failure: (f) => fail(f.message),
      );
    });

    test('GetAuthorRatingUseCase delegates to repository summary', () async {
      await rateUseCase.call(
        authorKey: 'author-valid',
        stars: 4,
      );

      final result = await getUseCase.call(authorKey: 'author-valid');
      result.when(
        success: (summary) {
          expect(summary.userStars, 4);
          expect(summary.ratingAvg, 4.0);
        },
        failure: (f) => fail(f.message),
      );
    });
  });

  group('ToggleArticleLikeUseCase execution and validations', () {
    late FakeArticleEngagementRepository repo;
    late ToggleArticleLikeUseCase toggleLikeUseCase;

    setUp(() {
      repo = FakeArticleEngagementRepository();
      toggleLikeUseCase = ToggleArticleLikeUseCase(repo);
    });

    test('Fails when articleId or userId is empty', () async {
      final res1 = await toggleLikeUseCase.call(
        articleId: '',
        userId: 'user-1',
        isCurrentlyLiked: false,
      );
      res1.when(
        success: (_) => fail('Expected failure'),
        failure: (f) => expect(f.message, contains('required')),
      );

      final res2 = await toggleLikeUseCase.call(
        articleId: 'art-1',
        userId: '',
        isCurrentlyLiked: false,
      );
      res2.when(
        success: (_) => fail('Expected failure'),
        failure: (f) => expect(f.message, contains('required')),
      );
    });

    test('Toggles unliked to liked', () async {
      final result = await toggleLikeUseCase.call(
        articleId: 'art-100',
        userId: 'user-100',
        isCurrentlyLiked: false,
      );

      result.when(
        success: (liked) => expect(liked, true),
        failure: (f) => fail(f.message),
      );
      expect(repo.likedArticles.contains('user-100:art-100'), true);
    });

    test('Toggles liked to unliked', () async {
      repo.likedArticles.add('user-100:art-100');
      final result = await toggleLikeUseCase.call(
        articleId: 'art-100',
        userId: 'user-100',
        isCurrentlyLiked: true,
      );

      result.when(
        success: (liked) => expect(liked, false),
        failure: (f) => fail(f.message),
      );
      expect(repo.likedArticles.contains('user-100:art-100'), false);
    });

    test('Propagates failure from repository', () async {
      repo.shouldFail = true;
      final result = await toggleLikeUseCase.call(
        articleId: 'art-100',
        userId: 'user-100',
        isCurrentlyLiked: false,
      );

      result.when(
        success: (_) => fail('Expected failure'),
        failure: (f) => expect(f.message, 'Network error'),
      );
    });
  });
}
