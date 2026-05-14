import 'package:dio/dio.dart';

import '../constants/app_endpoints.dart';

/// Optional bearer header helper if JWT is introduced later (current API is cookie sessions).
Map<String, dynamic> withBearer(Map<String, dynamic> headers, String token) {
  return {...headers, 'Authorization': 'Bearer $token'};
}

/// Attaches fresh CSRF before a mutating call (use when not relying on [CsrfInterceptor] alone).
Future<void> attachCsrfForRequest(Dio dio) async {
  await dio.get(AppEndpoints.authCsrf);
}
