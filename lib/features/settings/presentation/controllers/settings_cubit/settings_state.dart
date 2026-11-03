part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {
  final String displayName;
  final String userEmail;
  final String? avatarUrl;
  final UserEntity? currentUserEntity;
  final String fontScale;
  final double cachedMegabytes;

  const SettingsState({
    this.displayName = '',
    this.userEmail = '',
    this.avatarUrl,
    this.currentUserEntity,
    this.fontScale = AppConstants.defaultFontScale,
    this.cachedMegabytes = 0.0,
  });

  SettingsLoaded toLoaded({
    String? displayName,
    String? userEmail,
    String? avatarUrl,
    UserEntity? currentUserEntity,
    String? fontScale,
    double? cachedMegabytes,
  }) {
    return SettingsLoaded(
      displayName: displayName ?? this.displayName,
      userEmail: userEmail ?? this.userEmail,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentUserEntity: currentUserEntity ?? this.currentUserEntity,
      fontScale: fontScale ?? this.fontScale,
      cachedMegabytes: cachedMegabytes ?? this.cachedMegabytes,
    );
  }

  SettingsError toError(String message) {
    return SettingsError(
      message,
      displayName: displayName,
      userEmail: userEmail,
      avatarUrl: avatarUrl,
      currentUserEntity: currentUserEntity,
      fontScale: fontScale,
      cachedMegabytes: cachedMegabytes,
    );
  }
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial({
    super.displayName,
    super.userEmail,
    super.avatarUrl,
    super.currentUserEntity,
    super.fontScale,
    super.cachedMegabytes,
  });
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading({
    super.displayName,
    super.userEmail,
    super.avatarUrl,
    super.currentUserEntity,
    super.fontScale,
    super.cachedMegabytes,
  });
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    super.displayName,
    super.userEmail,
    super.avatarUrl,
    super.currentUserEntity,
    super.fontScale,
    super.cachedMegabytes,
  });

  SettingsLoaded copyWith({
    String? displayName,
    String? userEmail,
    String? avatarUrl,
    UserEntity? currentUserEntity,
    String? fontScale,
    double? cachedMegabytes,
  }) {
    return toLoaded(
      displayName: displayName,
      userEmail: userEmail,
      avatarUrl: avatarUrl,
      currentUserEntity: currentUserEntity,
      fontScale: fontScale,
      cachedMegabytes: cachedMegabytes,
    );
  }
}

final class SettingsError extends SettingsState {
  final String message;

  const SettingsError(
    this.message, {
    super.displayName,
    super.userEmail,
    super.avatarUrl,
    super.currentUserEntity,
    super.fontScale,
    super.cachedMegabytes,
  });
}
