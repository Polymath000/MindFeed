part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {
  final String displayName;
  final String userEmail;
  final String? avatarUrl;
  final UserEntity? currentUserEntity;
  final String fontScale;
  final bool serifMode;
  final bool bionicGuide;
  final bool morningBriefing;
  final bool breakingAlerts;
  final bool dataPreservation;
  final bool wifiOnly;
  final double cachedMegabytes;

  const SettingsState({
    this.displayName = '',
    this.userEmail = '',
    this.avatarUrl,
    this.currentUserEntity,
    this.fontScale = 'Standard',
    this.serifMode = true,
    this.bionicGuide = false,
    this.morningBriefing = true,
    this.breakingAlerts = true,
    this.dataPreservation = false,
    this.wifiOnly = true,
    this.cachedMegabytes = 0.0,
  });
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial({
    super.displayName,
    super.userEmail,
    super.avatarUrl,
    super.currentUserEntity,
    super.fontScale,
    super.serifMode,
    super.bionicGuide,
    super.morningBriefing,
    super.breakingAlerts,
    super.dataPreservation,
    super.wifiOnly,
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
    super.serifMode,
    super.bionicGuide,
    super.morningBriefing,
    super.breakingAlerts,
    super.dataPreservation,
    super.wifiOnly,
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
    super.serifMode,
    super.bionicGuide,
    super.morningBriefing,
    super.breakingAlerts,
    super.dataPreservation,
    super.wifiOnly,
    super.cachedMegabytes,
  });

  SettingsLoaded copyWith({
    String? displayName,
    String? userEmail,
    String? avatarUrl,
    UserEntity? currentUserEntity,
    String? fontScale,
    bool? serifMode,
    bool? bionicGuide,
    bool? morningBriefing,
    bool? breakingAlerts,
    bool? dataPreservation,
    bool? wifiOnly,
    double? cachedMegabytes,
  }) {
    return SettingsLoaded(
      displayName: displayName ?? this.displayName,
      userEmail: userEmail ?? this.userEmail,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentUserEntity: currentUserEntity ?? this.currentUserEntity,
      fontScale: fontScale ?? this.fontScale,
      serifMode: serifMode ?? this.serifMode,
      bionicGuide: bionicGuide ?? this.bionicGuide,
      morningBriefing: morningBriefing ?? this.morningBriefing,
      breakingAlerts: breakingAlerts ?? this.breakingAlerts,
      dataPreservation: dataPreservation ?? this.dataPreservation,
      wifiOnly: wifiOnly ?? this.wifiOnly,
      cachedMegabytes: cachedMegabytes ?? this.cachedMegabytes,
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
    super.serifMode,
    super.bionicGuide,
    super.morningBriefing,
    super.breakingAlerts,
    super.dataPreservation,
    super.wifiOnly,
    super.cachedMegabytes,
  });
}
