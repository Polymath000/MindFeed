import 'package:equatable/equatable.dart';

class AuthorFollowSummary extends Equatable {
  final int followersCount;
  final int followingCount;
  final bool isFollowing;

  const AuthorFollowSummary({
    this.followersCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
  });

  AuthorFollowSummary copyWith({
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
  }) {
    return AuthorFollowSummary(
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  List<Object?> get props => [followersCount, followingCount, isFollowing];
}
