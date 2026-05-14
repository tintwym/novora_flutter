import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

/// Browser / Wasm: send cookies on cross-origin requests to the API (session + CSRF).
void configureDioForPlatform(Dio dio) {
  dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
}
