import '../../core/constants/app_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/session/session_notifier.dart';
import '../../core/storage/local_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';

class AuthRepository {
  AuthRepository({AuthService? service}) : _service = service ?? AuthService();
  final AuthService _service;

  Future<UserModel> login(String email, String password) async {
    final user = await _service.signIn(email, password);
    SessionNotifier.instance.update(user);
    return user;
  }

  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    final user = await _service.register(email: email, password: password);
    SessionNotifier.instance.update(user);
    return user;
  }

  Future<void> forgotPassword(String email) =>
      _service.requestPasswordReset(email);

  Future<UserModel?> tryRestoreSession() async {
    final cached = LocalStorage.instance.userJson;
    if (cached == null || cached.isEmpty) return null;
    final user = await _service.me();
    if (user != null) {
      SessionNotifier.instance.update(user);
    }
    return user;
  }

  /// Reload role/profile from `/api/v1/me` after a role change in the database.
  Future<UserModel?> refreshProfile() => SessionNotifier.instance.refreshFromServer();

  Future<void> logout() async {
    try {
      await ApiClient.ensureCsrfToken();
      await ApiClient.dio.post(AppEndpoints.authLogout);
    } catch (_) {
      // Ignore network errors during logout.
    }
    await ApiClient.clearSession();
    DashboardService.clearCache();
    LocalStorage.instance.authToken = null;
    LocalStorage.instance.userJson = null;
    SessionNotifier.instance.clear();
  }
}
