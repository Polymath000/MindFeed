part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final double cachedMegabytes;
  final bool dataPreservation;
  final bool wifiOnly;

  const SettingsLoaded({
    required this.cachedMegabytes,
    required this.dataPreservation,
    required this.wifiOnly,
  });

  SettingsLoaded copyWith({
    double? cachedMegabytes,
    bool? dataPreservation,
    bool? wifiOnly,
  }) {
    return SettingsLoaded(
      cachedMegabytes: cachedMegabytes ?? this.cachedMegabytes,
      dataPreservation: dataPreservation ?? this.dataPreservation,
      wifiOnly: wifiOnly ?? this.wifiOnly,
    );
  }
}
