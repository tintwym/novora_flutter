import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import 'api_client.dart';

/// Maps Spring / Dio failures to [ApiException] with a readable message.
ApiException apiExceptionFromDio(DioException e) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout) {
    return ApiException(
      'Cannot reach the API (${ApiClient.baseUrl}). '
      'Start the Spring backend, set API_BASE_URL in novora_flutter/.env if needed, '
      'and use the same scheme (http/https) as this app. On Flutter web from a LAN IP, '
      'add that origin to backend app.cors.additional-origin-patterns.',
      e.response?.statusCode,
    );
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
