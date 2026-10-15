import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  void loadSettings() {
    // Mock loading from SharedPreferences or similar
    emit(const SettingsLoaded(
      cachedMegabytes: 18.4,
      dataPreservation: false,
      wifiOnly: true,
    ));
  }

  void clearCache() {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(currentState.copyWith(cachedMegabytes: 0.0));
    }
  }

  void toggleDataPreservation(bool value) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(currentState.copyWith(dataPreservation: value));
    }
  }

  void toggleWifiOnly(bool value) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(currentState.copyWith(wifiOnly: value));
    }
  }
}
