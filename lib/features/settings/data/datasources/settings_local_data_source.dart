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

  static const String _fontScaleKey = 'pref_font_scale';
  static const String _serifModeKey = 'pref_serif_mode';

  static String _fallbackFontScale = 'Standard';
  static bool _fallbackSerifMode = true;

  @override
  Future<ReaderPreferencesEntity> getReaderPreferences() async {
    String fontScale = _fallbackFontScale;
    bool serifMode = _fallbackSerifMode;

    try {
      final storedScale = SharedPreferencesSingleton.getString(_fontScaleKey);
      if (storedScale != null) {
        fontScale = storedScale;
        _fallbackFontScale = storedScale;
      }
      final storedSerif = SharedPreferencesSingleton.getBool(_serifModeKey);
      if (storedSerif != null) {
        serifMode = storedSerif;
        _fallbackSerifMode = storedSerif;
      }
    } catch (_) {
      // In-memory fallback if SharedPreferencesSingleton is uninitialized
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
      try {
        await SharedPreferencesSingleton.setString(_fontScaleKey, fontScale);
      } catch (_) {}
    }

    if (serifMode != null) {
      _fallbackSerifMode = serifMode;
      try {
        await SharedPreferencesSingleton.setBool(_serifModeKey, value: serifMode);
      } catch (_) {}
    }

    return getReaderPreferences();
  }
}
