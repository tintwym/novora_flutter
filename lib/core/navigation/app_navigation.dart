import 'package:flutter/material.dart';

import '../constants/app_routes.dart';

/// Sign out navigation must use the root [Navigator] — Settings and other modules
/// are shown inside the dashboard shell's nested navigator, which has no `/login` route.
void navigateToLogin(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
    AppRoutes.login,
    (route) => false,
  );
}
