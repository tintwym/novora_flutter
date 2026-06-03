import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWasm, kIsWeb;
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_endpoints.dart';
import 'cold_start_retry_interceptor.dart';
import 'csrf_interceptor.dart';
import 'dio_adapter_hook.dart' as dio_hook;

/// True for browser targets where [path_provider] / disk cookie jars are unavailable.
///
/// [kIsWeb] in recent Flutter is tied to `dart.library.js_interop`, which can be false on
/// some dart2js builds while `dart.library.html` is still true — so we also check `html`
/// and [kIsWasm] for Wasm web.
const bool _compileTimeClassicWeb = bool.fromEnvironment('dart.library.html');

bool _isBrowserTarget() =>
    kIsWeb || kIsWasm || _compileTimeClassicWeb;

/// [localhost], [127.0.0.1], and [[::1]] are different browser *sites* for cookies.
/// Flutter web is often served at `http://localhost:*` while `.env` points at `127.0.0.1`,
/// so `JSESSIONID` / `XSRF-TOKEN` are not sent on the next request → Spring CSRF returns 403.
bool _isLoopbackHost(String host) {
  final h = host.toLowerCase();
  return h == 'localhost' || h == '127.0.0.1' || h == '::1';
}

/// On web, rewrite API host to match [Uri.base.host] when both are loopback variants.
String _alignLoopbackHostForWeb(String url) {
  if (url.isEmpty) return url;
  if (!_isBrowserTarget()) return url;
  final pageHost = Uri.base.host;
  if (pageHost.isEmpty) return url;
  late final Uri u;
  try {
    u = Uri.parse(url);
  } catch (_) {
    return url;
  }
  if (!u.hasScheme || u.host.isEmpty) return url;
  if (!_isLoopbackHost(u.host) || !_isLoopbackHost(pageHost)) return url;
  if (u.host == pageHost) return url;
  return u.replace(host: pageHost).toString();
}

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
    if (_isBrowserTarget()) {
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
    const fromDefine = String.fromEnvironment('API_BASE_URL');
    // Widget / integration tests often skip [dotenv.load]; treat as unset.
    final rawEnv = fromDefine.isNotEmpty
        ? fromDefine.trim()
        : (dotenv.isInitialized ? dotenv.env['API_BASE_URL']?.trim() : null);
    final fromEnv = (rawEnv == null || rawEnv.isEmpty) ? null : rawEnv;
    final String resolved;
    // Same-origin API: Vercel rewrites `/api` + `/auth` → Render. Web needs an absolute origin (not "").
    if (fromEnv == '/' || fromEnv == 'same-origin') {
      resolved = _isBrowserTarget()
          ? Uri.base.origin
          : AppEndpoints.productionApiBase;
    } else if (fromEnv != null && fromEnv.isNotEmpty) {
      resolved =
          fromEnv.endsWith('/') ? fromEnv.substring(0, fromEnv.length - 1) : fromEnv;
    } else if (_isBrowserTarget()) {
      // `.env` missing in web build: on Vercel use page origin (proxied API); else local :8080.
      final h = Uri.base.host;
      if (h.endsWith('.vercel.app')) {
        resolved = Uri.base.origin;
      } else {
        resolved = h.isNotEmpty ? 'http://$h:8080' : 'http://127.0.0.1:8080';
      }
    } else {
      // Prefer loopback IP on native: avoids some macOS localhost → IPv6 (::1) mismatches with Java.
      resolved = 'http://127.0.0.1:8080';
    }
    return _alignLoopbackHostForWeb(resolved);
  }

  static Dio get dio {
    final resolved = baseUrl;
    if (_dio != null && _dio!.options.baseUrl != resolved) {
      _csrf.clear();
      _dio!.close(force: true);
      _dio = null;
    }
    _dio ??= _create();
    return _dio!;
  }

  static Dio _create() {
    final webTarget = _isBrowserTarget();
    final client = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        // Render free tier cold-start is ~30 s; the original 20/30 s budget timed
        // out on the very first request of the day even though the backend was
        // healthy. Headroom keeps the first login from surfacing a false "API
        // unreachable" banner.
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 75),
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
    // Retry order matters: cold-start retry is the *outermost* interceptor so the
    // replayed request re-runs CSRF + cookies on its way out.
    client.interceptors.add(ColdStartRetryInterceptor(dioRef: () => dio));
    return client;
  }

  /// Fire-and-forget ping to the backend so the first user-facing request does
  /// not pay Render's ~30 s free-tier cold-start. Failures are intentionally
  /// swallowed — this is a warm-up, not a health check.
  static void warmUp() {
    final base = baseUrl;
    if (base.isEmpty) return;
    final Uri uri;
    try {
      uri = Uri.parse('$base/actuator/health/liveness');
    } catch (_) {
      return;
    }
    Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 75),
      // Don't send cookies — warm-up should never mutate session state.
      extra: _isBrowserTarget() ? const <String, dynamic>{'withCredentials': false} : const {},
    )).getUri<dynamic>(uri).then((_) {}, onError: (_) {});
  }

  /// Clears HTTP state (cookies, CSRF token, Dio instance). Call on logout.
  static Future<void> clearSession() async {
    _csrf.clear();
    if (!_isBrowserTarget()) {
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
    if (!_csrf.hasToken) {
      throw DioException(
        requestOptions: RequestOptions(path: AppEndpoints.authCsrf, baseUrl: baseUrl),
        message:
            'CSRF token was not captured after GET ${AppEndpoints.authCsrf}. '
            'Check API URL, CORS/cookies (same host as the app tab on web), and backend /api/v1/auth/csrf.',
        type: DioExceptionType.unknown,
      );
    }
  }

  static Uri authLogin() => uri(AppEndpoints.authLogin);
}
