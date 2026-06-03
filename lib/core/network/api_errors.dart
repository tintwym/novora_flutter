import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWasm, kIsWeb;

import '../error/exceptions.dart';
import 'api_client.dart';

const bool _compileTimeClassicWeb = bool.fromEnvironment('dart.library.html');

bool _isBrowserTarget() => kIsWeb || kIsWasm || _compileTimeClassicWeb;

String? _springErrorMessage(Object? data) {
  if (data is! Map) return null;
  final map = Map<String, dynamic>.from(data);
  final err = map['error'];
  if (err is String && err.isNotEmpty) return err;
  final msg = map['message'];
  if (msg is String && msg.isNotEmpty) return msg;
  return null;
}

bool _webApiHostDiffersFromPage() {
  final base = ApiClient.baseUrl;
  if (base.isEmpty || base == '/' || base == 'same-origin') return false;
  final api = Uri.tryParse(base);
  if (api == null || !api.hasScheme || api.host.isEmpty) return false;
  final pageHost = Uri.base.host;
  if (pageHost.isEmpty) return false;
  return api.host != pageHost;
}

bool _looksLikeConnectionFailure(DioException e) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return true;
  }
  // Flutter web often reports failed requests as [unknown] with XMLHttpRequest in the message.
  if (e.type == DioExceptionType.unknown || e.response == null) {
    final m = e.message?.toLowerCase() ?? '';
    if (m.contains('xmlhttprequest') ||
        m.contains('socketexception') ||
        m.contains('connection refused') ||
        m.contains('failed host lookup') ||
        m.contains('network is unreachable') ||
        m.contains('client_disconnected')) {
      return true;
    }
  }
  return false;
}

/// Vercel returns 502/503/504 (or sometimes 408) when its `/api` rewrite cannot reach
/// the Render upstream — usually because the free-tier instance is cold and still booting.
/// Treat these the same as a connection failure so the cold-start hint shows up.
bool _looksLikeUpstreamCold(DioException e) {
  final status = e.response?.statusCode ?? 0;
  if (status == 408 || status == 502 || status == 503 || status == 504) {
    return true;
  }
  return false;
}

String _cannotReachApiMessage({int? status}) {
  final base = ApiClient.baseUrl;
  if (base.isEmpty) {
    return 'Cannot reach the API. Check API_BASE_URL and retry.';
  }
  // Same-origin proxying: baseUrl == page origin. Vercel forwards /api + /auth to Render.
  // If the request still failed, the proxy or upstream is the problem — not the client config.
  // The most common cause on Render's free tier is cold start (~30 s to wake an idle instance).
  if (_isBrowserTarget()) {
    final pageHost = Uri.base.host;
    final apiHost = Uri.tryParse(base)?.host ?? '';
    if (pageHost.isNotEmpty && apiHost == pageHost) {
      final prefix = status != null
          ? 'The API returned $status (likely a cold backend). '
          : 'The API did not respond. ';
      return '${prefix}On Render free tier the backend spins down after '
          '~15 min idle and takes ~30 s to wake up — wait a moment and retry. '
          'If it keeps failing, check the Render service is healthy and Vercel /api + /auth '
          'rewrites point at it.';
    }
  }
  return 'Cannot reach the API ($base). '
      'Start a backend on that host/port and retry. '
      'Local: ./scripts/run-backend-local.sh then API_BASE_URL=http://localhost:8080 in novora_flutter/.env. '
      'Production: set API_BASE_URL=same-origin on Vercel with /api + /auth rewrites to Render.';
}

/// Maps Spring / Dio failures to [ApiException] with a readable message.
ApiException apiExceptionFromDio(DioException e) {
  if (_looksLikeConnectionFailure(e)) {
    return ApiException(_cannotReachApiMessage(), e.response?.statusCode);
  }
  if (_looksLikeUpstreamCold(e)) {
    return ApiException(
      _cannotReachApiMessage(status: e.response?.statusCode),
      e.response?.statusCode,
    );
  }

  final response = e.response;
  final status = response?.statusCode;
  final data = response?.data;
  if (status == 403) {
    final bodyMsg = _springErrorMessage(data);
    if (bodyMsg != null &&
        (bodyMsg.toLowerCase().contains('bad credentials') ||
            bodyMsg.toLowerCase().contains('user not found'))) {
      return ApiException('Invalid email or password.', status);
    }
    final crossOrigin = _isBrowserTarget() && _webApiHostDiffersFromPage();
    final genericForbidden = bodyMsg == null ||
        bodyMsg.toLowerCase() == 'forbidden' ||
        bodyMsg.toLowerCase() == 'access denied';
    return ApiException(
      crossOrigin
          ? 'Request blocked (403). The app and API are on different sites, so login cookies '
              'cannot be sent. Production must use API_BASE_URL=same-origin with Vercel API rewrites.'
          : genericForbidden
              ? 'Request blocked (403). Your login session or CSRF cookie did not reach the API. '
                  'Sign out, hard-refresh, then sign in again. Local dev: run the backend with profile '
                  'local and use the same host in the browser and API_BASE_URL (localhost vs 127.0.0.1).'
              : bodyMsg,
      status,
    );
  }
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final msg = map['message'];
    if (msg is String && msg.isNotEmpty) {
      return ApiException(msg, status);
    }
    final err = map['errors'];
    if (err is Map) {
      final parts = err.entries.map((kv) => '${kv.key}: ${kv.value}').join(' ');
      if (parts.isNotEmpty) {
        return ApiException(parts, status);
      }
    }
  }
  if (e.message != null && e.message!.isNotEmpty) {
    return ApiException(e.message!, status);
  }
  return ApiException('Network error', status);
}
