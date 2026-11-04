import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';

import '../../domain/entities/reader_preferences_entity.dart';

abstract class SettingsLocalDataSource {
  Future<ReaderPreferencesEntity> getReaderPreferences();
  Future<ReaderPreferencesEntity> updateReaderPreferences({
    String? fontScale,
  });
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl();

  static String _fallbackFontScale = AppConstants.defaultFontScale;

  @override
  Future<ReaderPreferencesEntity> getReaderPreferences() async {
    String fontScale = _fallbackFontScale;

    if (SharedPreferencesSingleton.isInitialized) {
      try {
        final storedScale =
            SharedPreferencesSingleton.getString(AppConstants.fontScaleKey);
        if (storedScale != null) {
          fontScale = storedScale;
          _fallbackFontScale = storedScale;
        }
      } catch (_) {
        throw const CacheFailure(AppConstants.genericErrorMessage);
      }
    }

    return ReaderPreferencesEntity(
      fontScale: fontScale,
    );
  }

  @override
  Future<ReaderPreferencesEntity> updateReaderPreferences({
    String? fontScale,
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

    return getReaderPreferences();
  }
}
