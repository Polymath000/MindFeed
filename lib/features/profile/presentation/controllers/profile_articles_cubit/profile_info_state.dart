import 'package:equatable/equatable.dart';

sealed class ProfileInfoState extends Equatable {
  final String displayName;
  final String userSubtitle;
  final String? avatarUrl;
  final int followingCount;
  final int followersCount;
  final int followingAuthorsCount;
  final int articlesCount;
  final bool isUploadingAvatar;
  final String? avatarErrorMessage;

  const ProfileInfoState({
    this.displayName = '',
    this.userSubtitle = '',
    this.avatarUrl,
    this.followingCount = 0,
    this.followersCount = 0,
    this.followingAuthorsCount = 0,
    this.articlesCount = 0,
    this.isUploadingAvatar = false,
    this.avatarErrorMessage,
  });

  @override
  List<Object?> get props => [
        displayName,
        userSubtitle,
        avatarUrl,
        followingCount,
        followersCount,
        followingAuthorsCount,
        articlesCount,
        isUploadingAvatar,
        avatarErrorMessage,
      ];
}

final class ProfileInfoInitial extends ProfileInfoState {
  const ProfileInfoInitial({
    super.displayName,
    super.userSubtitle,
    super.avatarUrl,
    super.followingCount,
    super.followersCount,
    super.followingAuthorsCount,
    super.articlesCount,
    super.isUploadingAvatar,
    super.avatarErrorMessage,
  });
}

final class ProfileInfoLoading extends ProfileInfoState {
  const ProfileInfoLoading({
    super.displayName,
    super.userSubtitle,
    super.avatarUrl,
    super.followingCount,
    super.followersCount,
    super.followingAuthorsCount,
    super.articlesCount,
    super.isUploadingAvatar,
    super.avatarErrorMessage,
  });
}

final class ProfileInfoLoaded extends ProfileInfoState {
  const ProfileInfoLoaded({
    super.displayName,
    super.userSubtitle,
    super.avatarUrl,
    super.followingCount,
    super.followersCount,
    super.followingAuthorsCount,
    super.articlesCount,
    super.isUploadingAvatar,
    super.avatarErrorMessage,
  });

  ProfileInfoLoaded copyWith({
    String? displayName,
    String? userSubtitle,
    String? avatarUrl,
    int? followingCount,
    int? followersCount,
    int? followingAuthorsCount,
    int? articlesCount,
    bool? isUploadingAvatar,
    String? avatarErrorMessage,
  }) {
    return ProfileInfoLoaded(
      displayName: displayName ?? this.displayName,
      userSubtitle: userSubtitle ?? this.userSubtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      followingAuthorsCount:
          followingAuthorsCount ?? this.followingAuthorsCount,
      articlesCount: articlesCount ?? this.articlesCount,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      avatarErrorMessage: avatarErrorMessage ?? this.avatarErrorMessage,
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
    super.followersCount,
    super.followingAuthorsCount,
    super.articlesCount,
    super.isUploadingAvatar,
    super.avatarErrorMessage,
  });

  @override
  List<Object?> get props => [
        message,
        displayName,
        userSubtitle,
        avatarUrl,
        followingCount,
        followersCount,
        followingAuthorsCount,
        articlesCount,
        isUploadingAvatar,
        avatarErrorMessage,
      ];
}
