import '../../core/constants/app_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../firebase_options.dart';
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
    String? fullName,
    String? companyName,
  }) async {
    final user = await _service.register(
      email: email,
      password: password,
      fullName: fullName,
      companyName: companyName,
    );
    SessionNotifier.instance.update(user);
    return user;
  }

  Future<void> forgotPassword(String email) =>
      _service.requestPasswordReset(email);

  /// Re-hydrate a session from the server. The browser's `JSESSIONID` cookie is the
  /// source of truth — if it is still valid, `/me` returns the user even when this
  /// device has nothing cached (e.g. user refreshed without ticking "Remember me",
  /// which previously wiped the cache and forced them back to the login screen).
  ///
  /// Three outcomes:
  ///   * `UserModel`  — fresh from server; cache updated.
  ///   * `null`       — server returned 401/403 (no session). Local cache cleared so
  ///                    the route guard kicks the user to /login.
  ///   * throws       — transport / cold-start / timeout. Local cache is **kept**
  ///                    so the optimistic boot path in `main()` can leave the
  ///                    user where they were until the server is reachable again.
  Future<UserModel?> tryRestoreSession() async {
    final user = await _service.me();
    if (user != null) {
      SessionNotifier.instance.update(user);
      return user;
    }
    // Definitive "no session" from the server — wipe stale local state so the
    // app doesn't keep pretending the cached user is signed in.
    SessionNotifier.instance.clear();
    LocalStorage.instance.userJson = null;
    LocalStorage.instance.authToken = null;
    return null;
  }

  /// Reload role/profile from `/api/v1/me` after a role change in the database.
  Future<UserModel?> refreshProfile() => SessionNotifier.instance.refreshFromServer();

  Future<void> logout() async {
    try {
      if (!DefaultFirebaseOptions.isConfigured) {
        await ApiClient.ensureCsrfToken();
        await ApiClient.dio.post(AppEndpoints.authLogout);
      }
    } catch (_) {
      // Ignore network errors during logout.
    }
    await _service.signOutFirebase();
    await ApiClient.clearSession();
    DashboardService.clearCache();
    final storage = LocalStorage.instance;
    storage.authToken = null;
    storage.userJson = null;
    // Explicit logout reverts the "Remember me" opt-in so the next launch shows the login screen.
    storage.rememberMe = false;
    SessionNotifier.instance.clear();
  }
}
