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

String _cannotReachApiMessage() {
  final base = ApiClient.baseUrl;
  final target = base.isEmpty ? 'same-origin (check Vercel API rewrites)' : base;
  if (target.contains('novora-hrms.vercel.app')) {
    return 'API URL is set to the Vercel website ($target), not the Spring API. '
        'In Vercel → Environment Variables set API_BASE_URL=same-origin (not the app URL), '
        'redeploy, then try again. API lives on Render and is proxied via /api and /auth.';
  }
  return 'Cannot reach the API ($target). '
      'Start a backend on that host/port, then retry. '
      'Local: ./scripts/run-backend-local.sh then API_BASE_URL=http://localhost:8080 in novora_flutter/.env. '
      'Production: Vercel API_BASE_URL=same-origin with rewrites to Render.';
}

/// Maps Spring / Dio failures to [ApiException] with a readable message.
ApiException apiExceptionFromDio(DioException e) {
  if (_looksLikeConnectionFailure(e)) {
    return ApiException(_cannotReachApiMessage(), e.response?.statusCode);
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
    return ApiException(
      crossOrigin
          ? 'Request blocked (403). The app and API are on different sites, so login cookies '
              'cannot be sent. Production must use API_BASE_URL=same-origin with Vercel API rewrites.'
          : bodyMsg ??
              'Request blocked (403). Missing or invalid CSRF/session cookies. '
                  'Hard-refresh, clear cookies for this site, then sign in again.',
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
