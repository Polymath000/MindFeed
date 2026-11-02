import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';

abstract class AuthorFollowRemoteDataSource {
  Future<AuthorFollowSummary> getFollowSummary({
    required String targetUserId,
    String? viewerUserId,
  });

  Future<void> followAuthor({
    required String followerId,
    required String authorId,
  });

  Future<void> unfollowAuthor({
    required String followerId,
    required String authorId,
  });
}

class AuthorFollowRemoteDataSourceImpl implements AuthorFollowRemoteDataSource {
  final SupabaseClient? _supabaseClient;

  AuthorFollowRemoteDataSourceImpl({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  @override
  Future<AuthorFollowSummary> getFollowSummary({
    required String targetUserId,
    String? viewerUserId,
  }) async {
    final trimmedTarget = targetUserId.trim();
    final trimmedViewer = viewerUserId?.trim();

    final results = await Future.wait<dynamic>([
      _client
          .from('author_follows')
          .select('follower_id')
          .eq('author_id', trimmedTarget),
      _client
          .from('author_follows')
          .select('author_id')
          .eq('follower_id', trimmedTarget),
    ]);

    final followerRows = results[0] as List;
    final followingRows = results[1] as List;

    final isFollowing = (trimmedViewer != null && trimmedViewer.isNotEmpty)
        ? followerRows.any(
            (row) => row['follower_id']?.toString() == trimmedViewer,
          )
        : false;

    return AuthorFollowSummary(
      followersCount: followerRows.length,
      followingCount: followingRows.length,
      isFollowing: isFollowing,
    );
  }

  @override
  Future<void> followAuthor({
    required String followerId,
    required String authorId,
  }) async {
    await _client.from('author_follows').upsert(
      {
        'follower_id': followerId.trim(),
        'author_id': authorId.trim(),
      },
      onConflict: 'follower_id,author_id',
    );
  }

  @override
  Future<void> unfollowAuthor({
    required String followerId,
    required String authorId,
  }) async {
    await _client
        .from('author_follows')
        .delete()
        .eq('follower_id', followerId.trim())
        .eq('author_id', authorId.trim());
  }
}
