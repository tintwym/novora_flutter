import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../firebase_options.dart';
import '../../data/services/firebase_auth_gateway.dart';

/// Attaches a fresh Firebase ID token to every API request when Firebase Auth is enabled.
class FirebaseBearerInterceptor extends Interceptor {
  FirebaseBearerInterceptor({FirebaseAuthGateway? gateway})
      : _gateway = gateway ?? FirebaseAuthGateway();

  final FirebaseAuthGateway _gateway;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!DefaultFirebaseOptions.isActive) {
      handler.next(options);
      return;
    }
    try {
      final token = await _gateway.idToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } on FirebaseAuthException {
      // No signed-in user — let the request proceed; protected endpoints return 401.
    }
    handler.next(options);
  }
}
