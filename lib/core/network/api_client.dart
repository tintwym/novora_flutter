import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWasm, kIsWeb;
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_endpoints.dart';
import 'csrf_interceptor.dart';
import 'dio_adapter_hook.dart' as dio_hook;

/// True for browser targets where [path_provider] / disk cookie jars are unavailable.
///
/// [kIsWeb] in recent Flutter is tied to `dart.library.js_interop`, which can be false on
/// some dart2js builds while `dart.library.html` is still true — so we also check `html`
/// and [kIsWasm] for Wasm web.
const bool _compileTimeClassicWeb = bool.fromEnvironment('dart.library.html');

/// Global Dio client: Spring session cookies + CSRF for mutating calls.
abstract final class ApiClient {
  static CookieJar? _jar;
  static Future<void>? _jarInit;
  static final CsrfInterceptor _csrf = CsrfInterceptor();

  static Dio? _dio;

  static CookieJar get _cookieJar {
    return _jar ??= CookieJar();
  }

  /// Persists session cookies on mobile/desktop. On **web**, uses an in-memory
  /// jar only (`path_provider` / disk persistence is not available there).
  static Future<void> initPersistence() async {
    if (kIsWeb || kIsWasm || _compileTimeClassicWeb) {
      _jarInit ??= Future<void>.value();
      await _jarInit;
      return;
    }
    _jarInit ??= _initPersistJar();
    await _jarInit;
  }

  static Future<void> _initPersistJar() async {
    if (_jar is PersistCookieJar) return;
    try {
      final dir = await getApplicationSupportDirectory();
      final jar = PersistCookieJar(
        persistSession: true,
        storage: FileStorage('${dir.path}/novora_cookies/'),
      );
      await jar.forceInit();
      _jar = jar;
      _dio?.close(force: true);
      _dio = null;
    } on MissingPluginException {
      // e.g. web when compile-time web detection did not apply — memory cookies only.
    }
  }

  static String get baseUrl {
    final fromEnv = dotenv.env['API_BASE_URL']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv.endsWith('/') ? fromEnv.substring(0, fromEnv.length - 1) : fromEnv;
    }
    return 'http://localhost:8080';
  }

  static Dio get dio {
    _dio ??= _create();
    return _dio!;
  }

  static Dio _create() {
    final webTarget = kIsWeb || kIsWasm || _compileTimeClassicWeb;
    final client = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // Browser must send/receive `JSESSIONID` + `XSRF-TOKEN` for cross-origin API (e.g. Flutter web → Spring).
        extra: webTarget ? <String, dynamic>{'withCredentials': true} : const {},
      ),
    );
    dio_hook.configureDioForPlatform(client);
    // dio_cookie_manager is not supported on web (uses dart:io cookies; assert in debug).
    // With [withCredentials], the browser attaches cookies to the API origin automatically.
    if (!webTarget) {
      client.interceptors.add(CookieManager(_cookieJar));
    }
    client.interceptors.add(_csrf);
    return client;
  }

  /// Clears HTTP state (cookies, CSRF token, Dio instance). Call on logout.
  static Future<void> clearSession() async {
    _csrf.clear();
    if (!(kIsWeb || kIsWasm || _compileTimeClassicWeb)) {
      await _cookieJar.deleteAll();
    }
    _dio?.close(force: true);
    _dio = null;
  }

  static Uri uri(String path) {
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$p');
  }

  /// Prime CSRF cookie + header token before the first mutating request.
  static Future<void> ensureCsrfToken() async {
    await dio.get(AppEndpoints.authCsrf);
  }

  static Uri authLogin() => uri(AppEndpoints.authLogin);
}
