import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/repos/author_follow_repo.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';

sealed class AuthorFollowValidator {
  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  static bool isValidUuid(String? value) {
    if (value == null) return false;
    return _uuidPattern.hasMatch(value.trim());
  }

  static bool isSelf({
    required String? authorId,
    required String? viewerUserId,
  }) {
    final trimmedAuthor = authorId?.trim() ?? '';
    final trimmedViewer = viewerUserId?.trim() ?? '';
    if (trimmedAuthor.isEmpty || trimmedViewer.isEmpty) return false;
    return trimmedAuthor.toLowerCase() == trimmedViewer.toLowerCase();
  }

  static bool canShowFollowButton({
    required String? authorId,
    required String? viewerUserId,
  }) {
    if (!isValidUuid(authorId)) return false;
    return !isSelf(authorId: authorId, viewerUserId: viewerUserId);
  }
}

class GetAuthorFollowSummaryUseCase {
  final AuthorFollowRepository repository;

  const GetAuthorFollowSummaryUseCase(this.repository);

  Future<ApiResult<AuthorFollowSummary>> call({
    required String? targetUserId,
    String? viewerUserId,
  }) async {
    if (!AuthorFollowValidator.isValidUuid(targetUserId)) {
      return const Success(AuthorFollowSummary());
    }
    return repository.getFollowSummary(
      targetUserId: targetUserId!.trim(),
      viewerUserId: AuthorFollowValidator.isValidUuid(viewerUserId)
          ? viewerUserId!.trim()
          : null,
    );
  }
}

class ToggleAuthorFollowUseCase {
  final AuthorFollowRepository repository;

  const ToggleAuthorFollowUseCase(this.repository);

  Future<ApiResult<AuthorFollowSummary>> call({
    required String? followerId,
    required String? authorId,
    required bool currentlyFollowing,
  }) async {
    if (!AuthorFollowValidator.isValidUuid(followerId)) {
      return const FailureResult(
        ValidationFailure('Please sign in to follow authors'),
      );
    }
    if (!AuthorFollowValidator.isValidUuid(authorId)) {
      return const FailureResult(
        ValidationFailure('Author profile cannot be followed'),
      );
    }
    if (AuthorFollowValidator.isSelf(
      authorId: authorId,
      viewerUserId: followerId,
    )) {
      return const FailureResult(
        ValidationFailure('You cannot follow your own profile'),
      );
    }

    final cleanFollower = followerId!.trim();
    final cleanAuthor = authorId!.trim();

    final toggleResult = currentlyFollowing
        ? await repository.unfollowAuthor(
            followerId: cleanFollower,
            authorId: cleanAuthor,
          )
        : await repository.followAuthor(
            followerId: cleanFollower,
            authorId: cleanAuthor,
          );

    return switch (toggleResult) {
      FailureResult(:final failure) => FailureResult(failure),
      Success() => repository.getFollowSummary(
          targetUserId: cleanAuthor,
          viewerUserId: cleanFollower,
        ),
    };
  }
}
