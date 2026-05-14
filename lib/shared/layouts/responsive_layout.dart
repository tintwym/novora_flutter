import 'package:flutter/material.dart';

abstract final class ResponsiveLayout {
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 900;

  static bool isMedium(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= 600 && w < 900;
  }
}
