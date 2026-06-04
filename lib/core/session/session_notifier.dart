import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/dashboard_service.dart';
import '../storage/local_storage.dart';

/// Broadcasts when the signed-in user (especially [UserModel.primaryRole]) changes.
class SessionNotifier extends ChangeNotifier {
  SessionNotifier._();
  static final SessionNotifier instance = SessionNotifier._();

  UserModel? _user;
  bool _hydratedFromStorage = false;

  /// Active session, hydrated lazily from `LocalStorage.userJson` on first read.
  /// The first hydration is cached and notifies listeners so any widget that
  /// reads `user` before the explicit `update()` call still sees the same
  /// reference on subsequent reads (and triggers exactly one rebuild).
  UserModel? get user {
    if (_user != null) return _user;
    if (_hydratedFromStorage) return null;
    _hydratedFromStorage = true;
    _user = _loadFromStorage();
    return _user;
  }

  void update(UserModel? user) {
    _user = user;
    _hydratedFromStorage = true;
    notifyListeners();
  }

  void clear() {
    final wasSignedIn = _user != null;
    _user = null;
    _hydratedFromStorage = true;
    if (wasSignedIn) notifyListeners();
  }

  /// Loads latest role from `/api/v1/me` and refreshes the server session.
  ///
  /// * server returned a user → update the in-memory session.
  /// * server returned 401/403 → drop the in-memory session (so the UI stops
  ///   rendering the previous role's screens with stale data).
  /// * transport / cold-start / timeout → keep the current session so a
  ///   transient Render hiccup doesn't sign the user out mid-task.
  Future<UserModel?> refreshFromServer() async {
    UserModel? fresh;
    try {
      fresh = await AuthService().me();
    } catch (_) {
      // Inconclusive (network/timeout) — keep what we have.
      return _user;
    }
    if (fresh != null) {
      _user = fresh;
      _hydratedFromStorage = true;
      DashboardService.clearCache();
      notifyListeners();
    } else if (_user != null) {
      _user = null;
      _hydratedFromStorage = true;
      DashboardService.clearCache();
      notifyListeners();
    }
    return fresh;
  }

  UserModel? _loadFromStorage() {
    final raw = LocalStorage.instance.userJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromAuthJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
