import 'package:flutter/material.dart';

abstract final class ResponsiveLayout {
  static const double moduleSecondarySidebarMinWidth = 1200;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 900;

  /// Main app sidebar + module secondary nav (Reports, Settings) side by side.
  static bool showModuleSecondarySidebar(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= moduleSecondarySidebarMinWidth;

  static bool isMedium(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= 600 && w < 900;
  }
}
