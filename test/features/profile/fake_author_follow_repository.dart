import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/repos/author_follow_repo.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';

class FakeAuthorFollowRepository extends Fake implements AuthorFollowRepository {
  AuthorFollowSummary summary = const AuthorFollowSummary();
  bool shouldSucceed = true;

  @override
  Future<ApiResult<AuthorFollowSummary>> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Follow summary load failed'));
    }
    return Success(summary);
  }

  @override
  Future<ApiResult<void>> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Follow failed'));
    }
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  }) async {
    if (!shouldSucceed) {
      return const FailureResult(ServerFailure('Unfollow failed'));
    }
    return const Success(null);
  }
}
