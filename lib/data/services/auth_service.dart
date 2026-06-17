import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_errors.dart';
import '../../core/storage/local_storage.dart';
import '../../core/error/exceptions.dart';
import '../../firebase_options.dart';
import '../models/user_model.dart';
import 'firebase_auth_gateway.dart';

/// Authentication: Firebase ID tokens (production) or Spring session cookies (local fallback).
class AuthService {
  AuthService({FirebaseAuthGateway? firebase})
      : _firebase = firebase ?? FirebaseAuthGateway();

  final FirebaseAuthGateway _firebase;

  bool get _useFirebase => DefaultFirebaseOptions.isConfigured;

  Future<UserModel> signIn(String email, String password) async {
    if (_useFirebase) {
      try {
        await _firebase.signIn(email, password);
      } on FirebaseAuthException catch (e) {
        throw ApiException(_firebaseMessage(e), null);
      }
      return _loadProfileFromBackend();
    }
    return _legacySignIn(email, password);
  }

  Future<UserModel> register({
    required String email,
    required String password,
    String? fullName,
    String? companyName,
  }) async {
    if (_useFirebase) {
      final company = companyName?.trim() ?? '';
      if (company.length < 2) {
        throw const ApiException('Company name is required (2–120 characters).', 400);
      }
      try {
        await _firebase.signUp(email, password);
      } on FirebaseAuthException catch (e) {
        throw ApiException(_firebaseMessage(e), null);
      }
      try {
        await _ensureCsrf();
        final body = <String, dynamic>{
          'companyName': company,
        };
        final trimmedName = fullName?.trim();
        if (trimmedName != null && trimmedName.isNotEmpty) {
          body['fullName'] = trimmedName;
        }
        final res = await ApiClient.dio.post<Map<String, dynamic>>(
          AppEndpoints.authFirebaseRegister,
          data: body,
        );
        if ((res.statusCode != 201 && res.statusCode != 200) || res.data == null) {
          throw ApiException('Registration failed', res.statusCode);
        }
        final user = UserModel.fromAuthJson(res.data!);
        await _persist(user);
        return user;
      } on DioException catch (e) {
        // Workspace provisioning failed — tear down the Firebase user so retry is clean.
        await _firebase.signOut();
        throw apiExceptionFromDio(e);
      }
    }
    return _legacyRegister(
      email: email,
      password: password,
      fullName: fullName,
      companyName: companyName,
    );
  }

  Future<UserModel?> me() async {
    try {
      final res = await ApiClient.dio.get<Map<String, dynamic>>(AppEndpoints.me);
      if (res.statusCode != 200 || res.data == null) return null;
      final user = UserModel.fromAuthJson(res.data!);
      await _persist(user);
      if (!_useFirebase) {
        try {
          await _ensureCsrf();
        } catch (_) {
          // Session may still work for GETs.
        }
      }
      return user;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) return null;
      rethrow;
    }
  }

  Future<void> requestPasswordReset(String email) async {
    if (_useFirebase) {
      try {
        await _firebase.sendPasswordResetEmail(email);
      } on FirebaseAuthException catch (e) {
        throw ApiException(_firebaseMessage(e), null);
      }
      return;
    }
    throw const ApiException(
      'Password reset is not available yet. Contact your administrator.',
      501,
    );
  }

  Future<void> signOutFirebase() async {
    if (_useFirebase) {
      await _firebase.signOut();
    }
  }

  Future<UserModel> _loadProfileFromBackend() async {
    final user = await me();
    if (user == null) {
      throw const ApiException(
        'Workspace not set up yet. Please complete registration with your company name.',
        401,
      );
    }
    return user;
  }

  Future<UserModel> _legacySignIn(String email, String password) async {
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
      await _ensureCsrf();
      return user;
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }

  Future<UserModel> _legacyRegister({
    required String email,
    required String password,
    String? fullName,
    String? companyName,
  }) async {
    try {
      await _ensureCsrf();
      final body = <String, dynamic>{
        'email': email.trim(),
        'password': password,
      };
      final company = companyName?.trim();
      if (company != null && company.isNotEmpty) {
        body['companyName'] = company;
      }
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

  Future<void> _ensureCsrf() => ApiClient.ensureCsrfToken();

  Future<void> _persist(UserModel user) async {
    if (_useFirebase) {
      final token = await _firebase.idToken();
      LocalStorage.instance.authToken = token;
    } else {
      LocalStorage.instance.authToken = user.accessToken;
    }
    LocalStorage.instance.userJson = jsonEncode(user.toJson());
  }

  static String _firebaseMessage(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' || 'wrong-password' || 'invalid-credential' =>
        'Invalid email or password.',
      'email-already-in-use' => 'Email already registered.',
      'weak-password' => 'Password is too weak.',
      'invalid-email' => 'Enter a valid email address.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      _ => e.message ?? 'Authentication failed.',
    };
  }
}
