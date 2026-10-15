import 'package:flutter/foundation.dart' show immutable;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

@immutable
sealed class SharedPreferencesSingleton {
  const SharedPreferencesSingleton();
  static SharedPreferences? _instance;

  static Future<SharedPreferences> init() async =>
      _instance = await SharedPreferences.getInstance();

  static SharedPreferences get instance {
    if (_instance == null) {
      throw StateError('SharedPreferencesSingleton has not been initialized.');
    }
    return _instance!;
  }

  static Future<bool> setBool(final String key, {required final bool value}) =>
      instance.setBool(key, value);
  static Future<bool> setString(final String key, final String value) =>
      instance.setString(key, value);

  static bool? getBool(final String key) => instance.getBool(key);
  static String? getString(final String key) => instance.getString(key);
  static Set<String> getKeys() => instance.getKeys();

  static Future<bool> remove(final String key) => instance.remove(key);
  static Future<bool> clear() => instance.clear();
}
