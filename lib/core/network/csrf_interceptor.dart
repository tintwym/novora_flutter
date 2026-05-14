import 'package:dio/dio.dart';

/// Captures CSRF metadata from [AppEndpoints.authCsrf] and attaches it to mutating requests.
final class CsrfInterceptor extends Interceptor {
  String _headerName = 'X-XSRF-TOKEN';
  String? _token;

  void clear() {
    _token = null;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final path = response.requestOptions.path;
    // Spring exposes CSRF at `/api/v1/auth/csrf` (and `/auth/csrf`). Dio may decode JSON as
    // `Map<dynamic, dynamic>`, so accept any Map — a strict `Map<String, dynamic>` check misses
    // the token and mutating requests get 403.
    if (path.endsWith('/auth/csrf')) {
      final data = response.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final hn = map['headerName'];
        final tk = map['token'];
        if (hn is String && hn.isNotEmpty) {
          _headerName = hn;
        }
        if (tk is String && tk.isNotEmpty) {
          _token = tk;
        }
      }
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
