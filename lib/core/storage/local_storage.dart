import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper for [SharedPreferences] (token, theme, simple flags).
class LocalStorage {
  LocalStorage._(this._prefs);
  final SharedPreferences _prefs;

  static LocalStorage? _instance;
  static LocalStorage get instance {
    if (_instance == null) {
      throw StateError('Call LocalStorage.init() in main() first');
    }
    return _instance!;
  }

  static Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    _instance = LocalStorage._(p);
  }

  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user_json';
  String? get authToken => _prefs.getString(_kToken);
  set authToken(String? v) {
    if (v == null) {
      _prefs.remove(_kToken);
    } else {
      _prefs.setString(_kToken, v);
    }
  }

  String? get userJson => _prefs.getString(_kUser);

  set userJson(String? v) {
    if (v == null || v.isEmpty) {
      _prefs.remove(_kUser);
    } else {
      _prefs.setString(_kUser, v);
    }
  }

  @visibleForTesting
  static void resetForTest() => _instance = null;
}
