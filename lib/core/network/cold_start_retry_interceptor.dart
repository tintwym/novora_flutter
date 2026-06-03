import 'dart:async';

import 'package:dio/dio.dart';

/// Retries requests that look like Render free-tier cold-start failures.
///
/// Render's free instance spins down after ~15 min idle and takes ~30 s to
/// wake up. When the proxy in front of it (e.g. Vercel) gives up first the
/// client sees a 5xx; when the client gives up first it sees a connection
/// error or timeout. Either way, retrying after a short delay almost always
/// succeeds because the instance is finishing its boot by then.
///
/// This keeps the user from seeing a misleading "cannot reach API" banner on
/// the very first click of the day.
class ColdStartRetryInterceptor extends Interceptor {
  ColdStartRetryInterceptor({
    required this.dioRef,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 4),
  });

  /// Reference to the Dio instance this interceptor is attached to, used to
  /// replay the request through the full interceptor chain (CSRF, cookies,
  /// etc.) — replaying via a fresh Dio would lose those.
  final Dio Function() dioRef;
  final int maxRetries;
  final Duration retryDelay;

  /// Avoid retrying mutating requests that may have side effects on the server
  /// (POST is allowed because login is idempotent until it succeeds).
  static const _safeMethods = {'GET', 'HEAD', 'OPTIONS', 'POST'};

  static const _attemptKey = '_coldStartRetryAttempt';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final method = options.method.toUpperCase();
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;

    if (!_safeMethods.contains(method) ||
        attempt >= maxRetries ||
        !_isColdStart(err)) {
      return handler.next(err);
    }

    await Future<void>.delayed(retryDelay);

    try {
      final response = await dioRef().request<dynamic>(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        cancelToken: options.cancelToken,
        onReceiveProgress: options.onReceiveProgress,
        onSendProgress: options.onSendProgress,
        options: Options(
          method: options.method,
          headers: options.headers,
          responseType: options.responseType,
          contentType: options.contentType,
          validateStatus: options.validateStatus,
          receiveDataWhenStatusError: options.receiveDataWhenStatusError,
          followRedirects: options.followRedirects,
          maxRedirects: options.maxRedirects,
          listFormat: options.listFormat,
          sendTimeout: options.sendTimeout,
          receiveTimeout: options.receiveTimeout,
          extra: {
            ...options.extra,
            _attemptKey: attempt + 1,
          },
        ),
      );
      return handler.resolve(response);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    } catch (_) {
      return handler.next(err);
    }
  }

  bool _isColdStart(DioException e) {
    final status = e.response?.statusCode ?? 0;
    if (status == 408 || status == 502 || status == 503 || status == 504) {
      return true;
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return true;
    }
    if (e.type == DioExceptionType.unknown || e.response == null) {
      final m = e.message?.toLowerCase() ?? '';
      if (m.contains('xmlhttprequest') ||
          m.contains('socketexception') ||
          m.contains('connection refused') ||
          m.contains('failed host lookup') ||
          m.contains('network is unreachable') ||
          m.contains('client_disconnected') ||
          m.contains('router_external_target_error')) {
        return true;
      }
    }
    return false;
  }
}
