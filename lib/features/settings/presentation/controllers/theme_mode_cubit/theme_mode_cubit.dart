import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit() : super(const ThemeModeInitial()) {
    getThemeMode();
  }

  void getThemeMode() {
    try {
      final theme = SharedPreferencesSingleton.getString(AppConstants.themeModeKey);
      if (isClosed) return;
      if (theme == ThemeMode.light.name) {
        emit(const ThemeModeLight());
      } else if (theme == ThemeMode.dark.name) {
        emit(const ThemeModeDark());
      } else {
        emit(const ThemeModeSystem());
      }
    } catch (_) {
      if (!isClosed) {
        emit(const ThemeModeSystem());
      }
    }
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    try {
      await SharedPreferencesSingleton.setString(AppConstants.themeModeKey, themeMode.name);
    } catch (_) {}
    if (isClosed) return;
    if (themeMode == ThemeMode.light) {
      emit(const ThemeModeLight());
    } else if (themeMode == ThemeMode.dark) {
      emit(const ThemeModeDark());
    } else {
      emit(const ThemeModeSystem());
    }
  }
}
