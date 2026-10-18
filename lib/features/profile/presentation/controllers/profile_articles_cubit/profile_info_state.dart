import 'package:equatable/equatable.dart';

sealed class ProfileInfoState extends Equatable {
  final String displayName;
  final String userSubtitle;
  final String? avatarUrl;
  final int followingCount;
  final int articlesCount;

  const ProfileInfoState({
    this.displayName = '',
    this.userSubtitle = '',
    this.avatarUrl,
    this.followingCount = 0,
    this.articlesCount = 0,
  });

  @override
  List<Object?> get props => [
        displayName,
        userSubtitle,
        avatarUrl,
        followingCount,
        articlesCount,
      ];
}

final class ProfileInfoInitial extends ProfileInfoState {
  const ProfileInfoInitial({
    super.displayName,
    super.userSubtitle,
    super.avatarUrl,
    super.followingCount,
    super.articlesCount,
  });
}

final class ProfileInfoLoading extends ProfileInfoState {
  const ProfileInfoLoading({
    super.displayName,
    super.userSubtitle,
    super.avatarUrl,
    super.followingCount,
    super.articlesCount,
  });
}

final class ProfileInfoLoaded extends ProfileInfoState {
  const ProfileInfoLoaded({
    super.displayName,
    super.userSubtitle,
    super.avatarUrl,
    super.followingCount,
    super.articlesCount,
  });

  ProfileInfoLoaded copyWith({
    String? displayName,
    String? userSubtitle,
    String? avatarUrl,
    int? followingCount,
    int? articlesCount,
  }) {
    return ProfileInfoLoaded(
      displayName: displayName ?? this.displayName,
      userSubtitle: userSubtitle ?? this.userSubtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followingCount: followingCount ?? this.followingCount,
      articlesCount: articlesCount ?? this.articlesCount,
    );
  }
}

final class ProfileInfoError extends ProfileInfoState {
  final String message;

  const ProfileInfoError({
    required this.message,
    super.displayName,
    super.userSubtitle,
    super.avatarUrl,
    super.followingCount,
    super.articlesCount,
  });

  @override
  List<Object?> get props => [
        message,
        displayName,
        userSubtitle,
        avatarUrl,
        followingCount,
        articlesCount,
      ];
}
