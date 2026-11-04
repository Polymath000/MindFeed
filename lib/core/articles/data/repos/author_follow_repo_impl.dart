import 'package:mind_feed/core/articles/data/datasources/author_follow_remote_data_source.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/repos/author_follow_repo.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_error_handler.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/networking/network_info.dart';

class AuthorFollowRepositoryImpl implements AuthorFollowRepository {
  final AuthorFollowRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const AuthorFollowRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<ApiResult<AuthorFollowSummary>> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const FailureResult(ServerFailure('You are Offline'));
    }
    try {
      final summary = await remoteDataSource.getFollowSummary(
        targetUserId: targetUserId,
        authorKey: authorKey,
        viewerUserId: viewerUserId,
      );
      return Success(summary);
    } catch (e) {
      return FailureResult(ApiErrorHandler.handle(e).toFailure());
    }
  }

  @override
  Future<ApiResult<void>> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  }) async {
    if (!await networkInfo.isConnected) {
      return const FailureResult(ServerFailure('You are Offline'));
    }
    try {
      await remoteDataSource.followAuthor(
        followerId: followerId,
        authorKey: authorKey,
        authorId: authorId,
        authorName: authorName,
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(ApiErrorHandler.handle(e).toFailure());
    }
  }

  @override
  Future<ApiResult<void>> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const FailureResult(ServerFailure('You are Offline'));
    }
    try {
      await remoteDataSource.unfollowAuthor(
        followerId: followerId,
        authorKey: authorKey,
        authorId: authorId,
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(ApiErrorHandler.handle(e).toFailure());
    }
  }
}
