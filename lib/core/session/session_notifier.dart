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

  UserModel? get user => _user ?? _loadFromStorage();

  void update(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }

  /// Loads latest role from `/api/v1/me` and refreshes the server session (backend).
  Future<UserModel?> refreshFromServer() async {
    final fresh = await AuthService().me();
    if (fresh != null) {
      _user = fresh;
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
