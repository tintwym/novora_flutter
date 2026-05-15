import 'dart:convert';

import 'package:dio/dio.dart';

/// Captures CSRF metadata from [AppEndpoints.authCsrf] and attaches it to mutating requests.
final class CsrfInterceptor extends Interceptor {
  String _headerName = 'X-XSRF-TOKEN';
  String? _token;

  void clear() {
    _token = null;
  }

  bool get hasToken => _token != null && _token!.isNotEmpty;

  static bool _isCsrfEndpoint(RequestOptions ro) {
    final p = ro.uri.path;
    if (p.endsWith('/auth/csrf')) return true;
    // Absolute `path` or odd adapters: still detect Spring CSRF JSON endpoint.
    return ro.path.endsWith('/auth/csrf') || ro.path.contains('/auth/csrf');
  }

  void _applyBody(dynamic data) {
    Object? decoded = data;
    if (data is String && data.trim().isNotEmpty) {
      try {
        decoded = jsonDecode(data) as Object?;
      } catch (_) {
        return;
      }
    }
    if (decoded is! Map) return;
    final map = Map<String, dynamic>.from(decoded);
    final hn = map['headerName'];
    final tk = map['token'];
    if (hn is String && hn.isNotEmpty) {
      _headerName = hn;
    }
    if (tk is String && tk.isNotEmpty) {
      _token = tk;
    }
  }

  /// Spring also sets `XSRF-TOKEN` via [CookieCsrfTokenRepository]; some clients miss JSON parsing.
  void _applySetCookie(Response response) {
    if (_token != null && _token!.isNotEmpty) return;
    final re = RegExp(r'\bXSRF-TOKEN=([^;]+)', caseSensitive: false);
    void scan(String line) {
      final m = re.firstMatch(line);
      if (m == null) return;
      final raw = m.group(1)?.trim();
      if (raw == null || raw.isEmpty) return;
      try {
        _token = Uri.decodeFull(raw);
      } catch (_) {
        _token = raw;
      }
    }

    response.headers.forEach((name, values) {
      if (name.toLowerCase() != 'set-cookie') return;
      for (final v in values) {
        scan(v);
      }
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isCsrfEndpoint(response.requestOptions)) {
      _applyBody(response.data);
      _applySetCookie(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final m = options.method.toUpperCase();
    if (const {'POST', 'PUT', 'PATCH', 'DELETE'}.contains(m)) {
      final t = _token;
      if (t != null && t.isNotEmpty) {
        options.headers[_headerName] = t;
      }
    }
    handler.next(options);
  }
}
