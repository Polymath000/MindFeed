import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';

abstract class AuthorFollowRemoteDataSource {
  Future<AuthorFollowSummary> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  });

  Future<void> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  });

  Future<void> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  });
}

class AuthorFollowRemoteDataSourceImpl implements AuthorFollowRemoteDataSource {
  final SupabaseClient? _supabaseClient;

  AuthorFollowRemoteDataSourceImpl({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  static bool _isMissingAuthorKeyColumn(PostgrestException error) {
    final combined =
        '${error.code ?? ''} ${error.message} ${error.details ?? ''} ${error.hint ?? ''}'
            .toLowerCase();
    return combined.contains('author_key') ||
        combined.contains('author_name') ||
        error.code == '42703' ||
        error.code == 'PGRST204';
  }

  @override
  Future<AuthorFollowSummary> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  }) async {
    final cleanTargetUuid = AuthorFollowValidator.isValidUuid(targetUserId)
        ? targetUserId!.trim()
        : null;
    final canonicalKey = AuthorFollowValidator.resolveAuthorKey(
      authorId: cleanTargetUuid,
      authorKey: authorKey,
    );
    final trimmedViewer = viewerUserId?.trim().toLowerCase();

    final followingFuture = cleanTargetUuid != null
        ? _client
            .from('author_follows')
            .select('follower_id')
            .eq('follower_id', cleanTargetUuid)
        : Future<List<dynamic>>.value(const <dynamic>[]);

    List<dynamic> followerRows;
    try {
      if (canonicalKey.isEmpty) {
        followerRows = const <dynamic>[];
      } else if (cleanTargetUuid != null) {
        followerRows = await _client
            .from('author_follows')
            .select('follower_id')
            .or('author_key.eq.$canonicalKey,author_id.eq.$cleanTargetUuid');
      } else {
        followerRows = await _client
            .from('author_follows')
            .select('follower_id')
            .eq('author_key', canonicalKey);
      }
    } on PostgrestException catch (e) {
      if (!_isMissingAuthorKeyColumn(e)) rethrow;
      if (cleanTargetUuid != null) {
        followerRows = await _client
            .from('author_follows')
            .select('follower_id')
            .eq('author_id', cleanTargetUuid);
      } else {
        followerRows = const <dynamic>[];
      }
    }

    final followingRows = await followingFuture;

    final uniqueFollowers = followerRows
        .map((row) => row['follower_id']?.toString().trim().toLowerCase() ?? '')
        .where((id) => id.isNotEmpty)
        .toSet();

    final isFollowing = (trimmedViewer != null && trimmedViewer.isNotEmpty)
        ? uniqueFollowers.contains(trimmedViewer)
        : false;

    return AuthorFollowSummary(
      followersCount: uniqueFollowers.length,
      followingCount: followingRows.length,
      isFollowing: isFollowing,
    );
  }

  @override
  Future<void> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  }) async {
    final cleanFollower = followerId.trim();
    final cleanAuthorId =
        AuthorFollowValidator.isValidUuid(authorId) ? authorId!.trim() : null;
    final canonicalKey = AuthorFollowValidator.resolveAuthorKey(
      authorId: cleanAuthorId,
      authorKey: authorKey,
      authorName: authorName,
    );
    final cleanName = authorName?.trim();

    try {
      await _client.from('author_follows').upsert(
        {
          'follower_id': cleanFollower,
          'author_key': canonicalKey,
          if (cleanAuthorId != null) 'author_id': cleanAuthorId,
          if (cleanName != null && cleanName.isNotEmpty)
            'author_name': cleanName,
        },
        onConflict: 'follower_id,author_key',
        ignoreDuplicates: true,
      );
    } on PostgrestException catch (e) {
      if (!_isMissingAuthorKeyColumn(e)) rethrow;
      if (cleanAuthorId == null) {
        throw StateError(
          'Run the latest author_follows SQL migration in Supabase to follow editorial columnists.',
        );
      }
      await _client.from('author_follows').upsert(
        {
          'follower_id': cleanFollower,
          'author_id': cleanAuthorId,
        },
        onConflict: 'follower_id,author_id',
        ignoreDuplicates: true,
      );
    }
  }

  @override
  Future<void> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  }) async {
    final cleanFollower = followerId.trim();
    final cleanAuthorId =
        AuthorFollowValidator.isValidUuid(authorId) ? authorId!.trim() : null;
    final canonicalKey = AuthorFollowValidator.resolveAuthorKey(
      authorId: cleanAuthorId,
      authorKey: authorKey,
    );

    try {
      if (cleanAuthorId != null) {
        await _client
            .from('author_follows')
            .delete()
            .eq('follower_id', cleanFollower)
            .or('author_key.eq.$canonicalKey,author_id.eq.$cleanAuthorId');
      } else {
        await _client
            .from('author_follows')
            .delete()
            .eq('follower_id', cleanFollower)
            .eq('author_key', canonicalKey);
      }
    } on PostgrestException catch (e) {
      if (!_isMissingAuthorKeyColumn(e)) rethrow;
      if (cleanAuthorId == null) {
        throw StateError(
          'Run the latest author_follows SQL migration in Supabase to unfollow editorial columnists.',
        );
      }
      await _client
          .from('author_follows')
          .delete()
          .eq('follower_id', cleanFollower)
          .eq('author_id', cleanAuthorId);
    }
  }
}
