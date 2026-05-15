import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import 'api_client.dart';

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
    'In another terminal, from the repo root, run: ./scripts/run-backend-local.sh '
    '(H2, no Postgres). For Neon, run ./mvnw spring-boot:run in novora_backend/ with DB_* in .env. '
    'Set API_BASE_URL in novora_flutter/.env if the backend uses another host or port. '
    'Flutter web from a LAN IP needs that origin in backend app.cors.additional-origin-patterns.';

/// Maps Spring / Dio failures to [ApiException] with a readable message.
ApiException apiExceptionFromDio(DioException e) {
  if (_looksLikeConnectionFailure(e)) {
    return ApiException(_cannotReachApiMessage(), e.response?.statusCode);
  }

  final response = e.response;
  final status = response?.statusCode;
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
