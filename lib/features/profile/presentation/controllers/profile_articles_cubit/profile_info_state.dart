import 'package:equatable/equatable.dart';

sealed class ProfileInfoState extends Equatable {
  final String displayName;
  final String userSubtitle;
  final String? avatarUrl;
  final int followingCount;
  final int articlesCount;
  final bool isUploadingAvatar;
  final String? avatarErrorMessage;

  const ProfileInfoState({
    this.displayName = '',
    this.userSubtitle = '',
    this.avatarUrl,
    this.followingCount = 0,
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
    super.articlesCount,
    super.isUploadingAvatar,
    super.avatarErrorMessage,
  });

  ProfileInfoLoaded copyWith({
    String? displayName,
    String? userSubtitle,
    String? avatarUrl,
    int? followingCount,
    int? articlesCount,
    bool? isUploadingAvatar,
    String? avatarErrorMessage,
  }) {
    return ProfileInfoLoaded(
      displayName: displayName ?? this.displayName,
      userSubtitle: userSubtitle ?? this.userSubtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followingCount: followingCount ?? this.followingCount,
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
        articlesCount,
        isUploadingAvatar,
        avatarErrorMessage,
      ];
}
