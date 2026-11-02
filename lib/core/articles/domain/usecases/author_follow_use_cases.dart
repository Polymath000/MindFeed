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

  static String resolveAuthorKey({
    String? authorId,
    String? authorKey,
    String? authorName,
  }) {
    if (isValidUuid(authorId)) {
      return authorId!.trim().toLowerCase();
    }
    final trimmedKey = authorKey?.trim().toLowerCase() ?? '';
    if (trimmedKey.isNotEmpty) return trimmedKey;
    final trimmedName = authorName?.trim().toLowerCase() ?? '';
    return trimmedName;
  }

  static bool isSelf({
    String? authorId,
    String? authorKey,
    required String? viewerUserId,
  }) {
    final trimmedViewer = viewerUserId?.trim().toLowerCase() ?? '';
    if (trimmedViewer.isEmpty) return false;
    final trimmedAuthor = authorId?.trim().toLowerCase() ?? '';
    if (trimmedAuthor.isNotEmpty && trimmedAuthor == trimmedViewer) {
      return true;
    }
    final trimmedKey = authorKey?.trim().toLowerCase() ?? '';
    if (trimmedKey.isNotEmpty && trimmedKey == trimmedViewer) {
      return true;
    }
    return false;
  }

  static bool canShowFollowButton({
    String? authorId,
    String? authorKey,
    String? authorName,
    required String? viewerUserId,
  }) {
    final resolvedKey = resolveAuthorKey(
      authorId: authorId,
      authorKey: authorKey,
      authorName: authorName,
    );
    if (resolvedKey.isEmpty) return false;
    return !isSelf(
      authorId: authorId,
      authorKey: resolvedKey,
      viewerUserId: viewerUserId,
    );
  }
}

class GetAuthorFollowSummaryUseCase {
  final AuthorFollowRepository repository;

  const GetAuthorFollowSummaryUseCase(this.repository);

  Future<ApiResult<AuthorFollowSummary>> call({
    String? targetUserId,
    String? authorKey,
    String? authorName,
    String? viewerUserId,
  }) async {
    final resolvedKey = AuthorFollowValidator.resolveAuthorKey(
      authorId: targetUserId,
      authorKey: authorKey,
      authorName: authorName,
    );
    final validTargetUuid = AuthorFollowValidator.isValidUuid(targetUserId)
        ? targetUserId!.trim()
        : null;

    if (resolvedKey.isEmpty && validTargetUuid == null) {
      return const Success(AuthorFollowSummary());
    }

    return repository.getFollowSummary(
      targetUserId: validTargetUuid,
      authorKey: resolvedKey.isNotEmpty ? resolvedKey : null,
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
    String? authorId,
    String? authorKey,
    String? authorName,
    required bool currentlyFollowing,
  }) async {
    if (!AuthorFollowValidator.isValidUuid(followerId)) {
      return const FailureResult(
        ValidationFailure('Please sign in to follow authors'),
      );
    }

    final resolvedKey = AuthorFollowValidator.resolveAuthorKey(
      authorId: authorId,
      authorKey: authorKey,
      authorName: authorName,
    );
    if (resolvedKey.isEmpty) {
      return const FailureResult(
        ValidationFailure('Author profile cannot be followed'),
      );
    }

    if (AuthorFollowValidator.isSelf(
      authorId: authorId,
      authorKey: resolvedKey,
      viewerUserId: followerId,
    )) {
      return const FailureResult(
        ValidationFailure('You cannot follow your own profile'),
      );
    }

    final cleanFollower = followerId!.trim();
    final cleanAuthorId = AuthorFollowValidator.isValidUuid(authorId)
        ? authorId!.trim()
        : (AuthorFollowValidator.isValidUuid(resolvedKey) ? resolvedKey : null);
    final cleanAuthorName = authorName?.trim();

    final toggleResult = currentlyFollowing
        ? await repository.unfollowAuthor(
            followerId: cleanFollower,
            authorKey: resolvedKey,
            authorId: cleanAuthorId,
          )
        : await repository.followAuthor(
            followerId: cleanFollower,
            authorKey: resolvedKey,
            authorId: cleanAuthorId,
            authorName: cleanAuthorName,
          );

    return switch (toggleResult) {
      FailureResult(:final failure) => FailureResult(failure),
      Success() => repository.getFollowSummary(
          targetUserId: cleanAuthorId,
          authorKey: resolvedKey,
          viewerUserId: cleanFollower,
        ),
    };
  }
}
