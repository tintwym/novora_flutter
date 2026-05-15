import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWasm, kIsWeb;

import '../error/exceptions.dart';
import 'api_client.dart';

const bool _compileTimeClassicWeb = bool.fromEnvironment('dart.library.html');

bool _isBrowserTarget() => kIsWeb || kIsWasm || _compileTimeClassicWeb;

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
      e.type == DioExceptionType.connectionTimeout) {
    return true;
  }
  // Flutter web often reports failed requests as [unknown] with XMLHttpRequest in the message.
  if (e.type == DioExceptionType.unknown || e.response == null) {
    final m = e.message?.toLowerCase() ?? '';
    if (m.contains('xmlhttprequest') ||
        m.contains('socketexception') ||
        m.contains('connection refused') ||
        m.contains('failed host lookup') ||
        m.contains('network is unreachable')) {
      return true;
    }
  }
  return false;
}

String _cannotReachApiMessage() =>
    'Cannot reach the API (${ApiClient.baseUrl}). '
    'Start a backend on that host/port, then retry. '
    'Quick options from repo root: '
    './scripts/run-backend-local.sh (H2, no Docker) '
    'or ./scripts/run-api-docker.sh (Postgres + API in Docker). '
    'Neon: cd novora_backend && ./mvnw spring-boot:run with DB_* in novora_backend/.env. '
    'Override URL in novora_flutter/.env as API_BASE_URL=… '
    '(use http://localhost:PORT for Flutter web on localhost).';

/// Maps Spring / Dio failures to [ApiException] with a readable message.
ApiException apiExceptionFromDio(DioException e) {
  if (_looksLikeConnectionFailure(e)) {
    return ApiException(_cannotReachApiMessage(), e.response?.statusCode);
  }

  final response = e.response;
  final status = response?.statusCode;
  if (status == 403) {
    final crossOrigin = _isBrowserTarget() && _webApiHostDiffersFromPage();
    return ApiException(
      crossOrigin
          ? 'Request blocked (403). The app and API are on different sites, so login cookies '
              'cannot be sent. Production must use API_BASE_URL=same-origin with Vercel API rewrites.'
          : 'Request blocked (403). Missing or invalid CSRF/session cookies. '
              'Hard-refresh, clear cookies for this site, then sign in again.',
      status,
    );
  }
  final data = response?.data;
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
