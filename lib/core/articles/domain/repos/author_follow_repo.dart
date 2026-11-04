import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/networking/api_result.dart';

abstract class AuthorFollowRepository {
  Future<ApiResult<AuthorFollowSummary>> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  });

  Future<ApiResult<void>> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  });

  Future<ApiResult<void>> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  });
}
