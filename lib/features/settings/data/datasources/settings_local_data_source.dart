import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';

import '../../domain/entities/reader_preferences_entity.dart';

abstract class SettingsLocalDataSource {
  Future<ReaderPreferencesEntity> getReaderPreferences();
  Future<ReaderPreferencesEntity> updateReaderPreferences({
    String? fontScale,
    bool? serifMode,
  });
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl();

  static String _fallbackFontScale = AppConstants.defaultFontScale;
  static bool _fallbackSerifMode = true;

  @override
  Future<ReaderPreferencesEntity> getReaderPreferences() async {
    String fontScale = _fallbackFontScale;
    bool serifMode = _fallbackSerifMode;

    if (SharedPreferencesSingleton.isInitialized) {
      try {
        final storedScale =
            SharedPreferencesSingleton.getString(AppConstants.fontScaleKey);
        if (storedScale != null) {
          fontScale = storedScale;
          _fallbackFontScale = storedScale;
        }
        final storedSerif =
            SharedPreferencesSingleton.getBool(AppConstants.serifModeKey);
        if (storedSerif != null) {
          serifMode = storedSerif;
          _fallbackSerifMode = storedSerif;
        }
      } catch (_) {
        throw const CacheFailure(AppConstants.genericErrorMessage);
      }
    }

    return ReaderPreferencesEntity(
      fontScale: fontScale,
      serifMode: serifMode,
    );
  }

  @override
  Future<ReaderPreferencesEntity> updateReaderPreferences({
    String? fontScale,
    bool? serifMode,
  }) async {
    if (fontScale != null) {
      _fallbackFontScale = fontScale;
      if (SharedPreferencesSingleton.isInitialized) {
        try {
          await SharedPreferencesSingleton.setString(
            AppConstants.fontScaleKey,
            fontScale,
          );
        } catch (_) {
          throw const CacheFailure(AppConstants.genericErrorMessage);
        }
      }
    }

    if (serifMode != null) {
      _fallbackSerifMode = serifMode;
      if (SharedPreferencesSingleton.isInitialized) {
        try {
          await SharedPreferencesSingleton.setBool(
            AppConstants.serifModeKey,
            value: serifMode,
          );
        } catch (_) {
          throw const CacheFailure(AppConstants.genericErrorMessage);
        }
      }
    }

    return getReaderPreferences();
  }
}
