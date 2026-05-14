import 'package:flutter/material.dart';

/// Layout breakpoints for mobile / tablet / desktop shells.
abstract final class ResponsiveHelper {
  static const double mobileMax = 600;
  static const double tabletMax = 1100;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w > mobileMax && w <= tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width > tabletMax;
}
