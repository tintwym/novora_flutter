import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/app_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_errors.dart';
import '../../core/storage/local_storage.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Spring Security session login/register (`JSESSIONID` + CSRF cookies via Dio).
class AuthService {
  Future<void> _ensureCsrf() => ApiClient.ensureCsrfToken();

  Future<UserModel> signIn(String email, String password) async {
    try {
      await _ensureCsrf();
      final res = await ApiClient.dio.post<Map<String, dynamic>>(
        AppEndpoints.authLogin,
        data: {
          'email': email.trim(),
          'password': password,
        },
      );
      if (res.statusCode != 200 || res.data == null) {
        throw ApiException('Login failed', res.statusCode);
      }
      final user = UserModel.fromAuthJson(res.data!);
      await _persist(user);
      // Login creates a new session; CSRF from pre-login is invalid → refresh before any POST.
      await _ensureCsrf();
      return user;
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      await _ensureCsrf();
      final body = <String, dynamic>{
        'email': email.trim(),
        'password': password,
      };
      final trimmedName = fullName?.trim();
      if (trimmedName != null && trimmedName.isNotEmpty) {
        body['fullName'] = trimmedName;
      }
      final res = await ApiClient.dio.post<Map<String, dynamic>>(
        AppEndpoints.authRegister,
        data: body,
      );
      if ((res.statusCode != 201 && res.statusCode != 200) || res.data == null) {
        throw ApiException('Registration failed', res.statusCode);
      }
      final user = UserModel.fromAuthJson(res.data!);
      await _persist(user);
      await _ensureCsrf();
      return user;
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }

  Future<UserModel?> me() async {
    try {
      final res = await ApiClient.dio.get<Map<String, dynamic>>(AppEndpoints.me);
      if (res.statusCode != 200 || res.data == null) return null;
      final user = UserModel.fromAuthJson(res.data!);
      await _persist(user);
      try {
        await _ensureCsrf();
      } catch (_) {
        // Session may still work for GETs; punch will retry CSRF.
      }
      return user;
    } on DioException {
      return null;
    }
  }

  /// Backend does not expose password reset yet — reserved for future endpoint.
  Future<void> requestPasswordReset(String email) async {
    throw const ApiException(
      'Password reset is not available yet. Contact your administrator.',
      501,
    );
  }

  Future<void> _persist(UserModel user) async {
    final token = user.accessToken;
    LocalStorage.instance.authToken = token;
    LocalStorage.instance.userJson = jsonEncode(user.toJson());
  }
}
