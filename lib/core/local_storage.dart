import 'package:shared_preferences/shared_preferences.dart';

/// Simple wrapper around [SharedPreferences] for storing simple key‑value pairs.
class LocalStorage {
  static SharedPreferences? _prefs;

  /// Initialize the preferences instance. Must be called before any other method.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static String? getString(String key) => _prefs?.getString(key);
  static Future<bool> setString(String key, String value) => _prefs!.setString(key, value);

  static bool getBool(String key) => _prefs?.getBool(key) ?? false;
  static Future<bool> setBool(String key, bool value) => _prefs!.setBool(key, value);
}
