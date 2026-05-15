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
