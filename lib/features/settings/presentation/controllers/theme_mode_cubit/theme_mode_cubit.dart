import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit() : super(const ThemeModeLight()) {
    getThemeMode();
  }

  void getThemeMode() {
    try {
      final theme = SharedPreferencesSingleton.getString(AppConstants.themeModeKey);
      if (isClosed) return;
      if (theme == ThemeMode.dark.name) {
        emit(const ThemeModeDark());
      } else if (theme == ThemeMode.system.name) {
        emit(const ThemeModeSystem());
      } else {
        emit(const ThemeModeLight());
      }
    } catch (_) {
      debugPrint(const CacheFailure(AppConstants.genericErrorMessage).message);
      if (!isClosed) {
        emit(const ThemeModeLight());
      }
    }
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    try {
      await SharedPreferencesSingleton.setString(AppConstants.themeModeKey, themeMode.name);
    } catch (_) {
      debugPrint(const CacheFailure(AppConstants.genericErrorMessage).message);
      if (!isClosed) {
        emit(const ThemeModeLight());
      }
      return;
    }
    if (isClosed) return;
    if (themeMode == ThemeMode.dark) {
      emit(const ThemeModeDark());
    } else if (themeMode == ThemeMode.system) {
      emit(const ThemeModeSystem());
    } else {
      emit(const ThemeModeLight());
    }
  }
}
