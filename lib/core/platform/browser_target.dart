import 'package:flutter/foundation.dart';

/// True when running in a browser (dart2js, Wasm web, or classic `dart:html` web).
///
/// Matches [ApiClient] browser detection so logo + API URL behaviour stay aligned.
bool get isBrowserPlatform {
  const classicWeb = bool.fromEnvironment('dart.library.html');
  return kIsWeb || kIsWasm || classicWeb;
}
