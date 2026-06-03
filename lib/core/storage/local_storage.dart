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
  static const _kRememberMe = 'auth_remember_me';
  static const _kRememberedEmail = 'auth_remembered_email';
  static const _kThemePreference = 'theme_preference';
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

  /// When false, session is treated as transient — next app launch returns to login.
  bool get rememberMe => _prefs.getBool(_kRememberMe) ?? false;
  set rememberMe(bool v) => _prefs.setBool(_kRememberMe, v);

  /// Prefills the email field on the login screen.
  String? get rememberedEmail => _prefs.getString(_kRememberedEmail);
  set rememberedEmail(String? v) {
    if (v == null || v.isEmpty) {
      _prefs.remove(_kRememberedEmail);
    } else {
      _prefs.setString(_kRememberedEmail, v);
    }
  }

  /// User's theme override. Returns 'auto' | 'light' | 'dark'. Defaults to 'auto'
  /// so existing users keep the sunrise/sunset behaviour they had before this
  /// preference was added.
  String get themePreference => _prefs.getString(_kThemePreference) ?? 'auto';
  set themePreference(String v) => _prefs.setString(_kThemePreference, v);

  @visibleForTesting
  static void resetForTest() => _instance = null;
}
