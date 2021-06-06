import 'package:shared_preferences/shared_preferences.dart';

class NotInitializedException implements Exception {
  String _message;

  NotInitializedException([
    String message =
        'Preferences not initialized, call [RecPreferences.initialize()] before using it',
  ]) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

/// A static wrapper and additional funcionality on top of shared_preferences
class RecPreferences {
  static SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool isInitialized() {
    return _prefs != null;
  }

  static Future<bool> set(String key, dynamic value) {
    if (!isInitialized()) {
      throw NotInitializedException();
    }

    if (value is String) {
      return RecPreferences.setString(key, value);
    }

    if (value is int) {
      return RecPreferences.setInt(key, value);
    }

    if (value is bool) {
      return RecPreferences.setBool(key, value);
    }

    if (value is double) {
      return RecPreferences.setDouble(key, value);
    }

    return null;
  }

  static Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  static Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  static Object get(String key, {Object defaultValue}) {
    if (!isInitialized()) {
      throw NotInitializedException();
    }

    return _prefs.get(key) ?? defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static double getDouble(String key, {double defaultValue = 0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }
}
