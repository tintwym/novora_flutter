import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
/// Firebase web/mobile config loaded from `.env` / `--dart-define`.
///
/// Run `flutterfire configure` in a real Firebase project, then copy the values
/// into `.env` (see `.env.example`). When [isActive] is false the app falls
/// back to legacy Spring session cookies (local dev without Firebase).
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static const _apiKeyDefine = String.fromEnvironment('FIREBASE_API_KEY');
  static const _authDomainDefine = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const _projectIdDefine = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _storageBucketDefine =
      String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const _messagingSenderIdDefine =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const _appIdDefine = String.fromEnvironment('FIREBASE_APP_ID');
  static const _measurementIdDefine =
      String.fromEnvironment('FIREBASE_MEASUREMENT_ID');

  static String? _env(String key) {
    if (!dotenv.isInitialized) return null;
    final v = dotenv.env[key]?.trim();
    return (v == null || v.isEmpty) ? null : v;
  }

  static String? _pick(String define, String envKey) {
    if (define.isNotEmpty) return define;
    return _env(envKey);
  }

  static bool get isConfigured {
    try {
      currentPlatform;
      return true;
    } on StateError {
      return false;
    }
  }

  /// Keys are present **and** [Firebase.initializeApp] succeeded this session.
  static bool get isActive => isConfigured && Firebase.apps.isNotEmpty;

  static FirebaseOptions get currentPlatform {
    final apiKey = _pick(_apiKeyDefine, 'FIREBASE_API_KEY');
    final authDomain = _pick(_authDomainDefine, 'FIREBASE_AUTH_DOMAIN');
    final projectId = _pick(_projectIdDefine, 'FIREBASE_PROJECT_ID');
    final appId = _pick(_appIdDefine, 'FIREBASE_APP_ID');
    final messagingSenderId =
        _pick(_messagingSenderIdDefine, 'FIREBASE_MESSAGING_SENDER_ID');
    if (apiKey == null ||
        authDomain == null ||
        projectId == null ||
        appId == null ||
        messagingSenderId == null) {
      throw StateError(
        'Firebase is not configured. Set FIREBASE_* keys in .env — see .env.example.',
      );
    }
    return FirebaseOptions(
      apiKey: apiKey,
      authDomain: authDomain,
      projectId: projectId,
      storageBucket: _pick(_storageBucketDefine, 'FIREBASE_STORAGE_BUCKET'),
      messagingSenderId: messagingSenderId,
      appId: appId,
      measurementId: _pick(_measurementIdDefine, 'FIREBASE_MEASUREMENT_ID'),
    );
  }

  static void logIfDisabled() {
    if (!isConfigured && kDebugMode) {
      debugPrint(
        'Firebase Auth disabled — using Spring session cookies. '
        'Add FIREBASE_* to .env to enable.',
      );
    }
  }
}
