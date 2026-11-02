import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/repos/author_follow_repo.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class FakeAuthorArticlesRepository extends Fake implements ArticlesRepository {
  List<ArticleEntity> feedArticles = [];
  bool shouldSucceed = true;
  String errorMessage = 'Failed to load feed';

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    if (!shouldSucceed) {
      return FailureResult(ServerFailure(errorMessage));
    }
    return Success(List.from(feedArticles));
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (!shouldSucceed) {
      return FailureResult(ServerFailure(errorMessage));
    }
    return Success(
      feedArticles.where((a) => a.authorId == authorId).toList(),
    );
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (!shouldSucceed) {
      return FailureResult(ServerFailure(errorMessage));
    }
    return Success(
      feedArticles.where((a) => a.tags.contains(tag)).toList(),
    );
  }
}

class FakeAuthorFollowRepository extends Fake implements AuthorFollowRepository {
  int followersCount = 10;
  bool isFollowing = false;
  bool shouldSucceed = true;

  @override
  Future<ApiResult<AuthorFollowSummary>> getFollowSummary({
    required String targetUserId,
    String? viewerUserId,
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Follow service failed'));
    }
    return Success(
      AuthorFollowSummary(
        followersCount: followersCount,
        isFollowing: isFollowing,
      ),
    );
  }

  @override
  Future<ApiResult<void>> followAuthor({
    required String followerId,
    required String authorId,
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Follow failed'));
    }
    isFollowing = true;
    followersCount++;
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unfollowAuthor({
    required String followerId,
    required String authorId,
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Unfollow failed'));
    }
    isFollowing = false;
    followersCount = (followersCount > 0) ? followersCount - 1 : 0;
    return const Success(null);
  }
}

class FakeAuthorEngagementRepository extends Fake
    implements ArticleEngagementRepository {
  int userStars = 0;
  double ratingAvg = 4.5;
  int ratingCount = 12;
  bool shouldSucceed = true;

  @override
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Rating failed'));
    }
    userStars = stars;
    ratingCount++;
    ratingAvg = 4.8;
    return Success(
      AuthorRatingSummary(
        authorKey: authorKey,
        userStars: userStars,
        ratingAvg: ratingAvg,
        ratingCount: ratingCount,
      ),
    );
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Failed to get author rating'));
    }
    return Success(
      AuthorRatingSummary(
        authorKey: authorKey,
        userStars: userStars,
        ratingAvg: ratingAvg,
        ratingCount: ratingCount,
      ),
    );
  }
}

class FakeProfileRepository extends Fake implements ProfileRepository {
  Map<String, dynamic> profileData = {};
  bool shouldSucceed = true;

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Profile not found'));
    }
    return Success(Map<String, dynamic>.from(profileData));
  }
}
