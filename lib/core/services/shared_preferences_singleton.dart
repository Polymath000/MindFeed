import 'package:flutter/foundation.dart' show immutable;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

@immutable
sealed class SharedPreferencesSingleton {
  const SharedPreferencesSingleton();
  static late final SharedPreferences _instance;

  static Future<SharedPreferences> init() async =>
      _instance = await SharedPreferences.getInstance();

  /// Setters
  static Future<bool> setBool(final String key, {required final bool value}) =>
      _instance.setBool(key, value);
  static Future<bool> setString(final String key, final String value) =>
      _instance.setString(key, value);

  /// Getters
  static bool? getBool(final String key) => _instance.getBool(key);
  static String? getString(final String key) => _instance.getString(key);

  /// Removers
  static Future<bool> remove(final String key) => _instance.remove(key);
  static Future<bool> clear() => _instance.clear();
}
