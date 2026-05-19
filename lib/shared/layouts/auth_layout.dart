import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import 'responsive_layout.dart';

/// Split-screen layout for login / register / forgot-password flows.
///
/// Wide: form (left, white) + brand hero (right, navy). Logo lives on the form side
/// because the wordmark PNG has a white background.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.form});

  final Widget form;

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveLayout.isWide(context);
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      body: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: form),
                const Expanded(child: _BrandPanel()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 220,
                  child: _BrandPanel(compact: true),
                ),
                Expanded(child: form),
              ],
            ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.navyGrad),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          _ring(300, top: -100, right: -100),
          _ring(220, top: 180, right: -50),
          _ring(160, bottom: 40, left: 40),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 24 : 48,
                vertical: compact ? 20 : 48,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tight = compact && constraints.maxHeight < 140;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: GoogleFonts.sora(
                            fontSize: compact ? (tight ? 20 : 24) : 32,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Manage Your\n',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Workforce',
                              style: TextStyle(
                                color: AppColors.brandBlueSoft,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' with\n',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Precision.',
                              style: TextStyle(
                                color: Color(0xFFE2E8F0),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: compact ? 12 : 16),
                      Container(
                        width: 56,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGrad,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (!tight) ...[
                        SizedBox(height: compact ? 12 : 20),
                        Text(
                          'Novora HRMS empowers organizations to streamline processes, enhance productivity, and drive growth.',
                          textAlign: TextAlign.center,
                          maxLines: compact ? 3 : 4,
                          style: GoogleFonts.dmSans(
                            fontSize: compact ? 13 : 15,
                            color: const Color(0xFF94A3B8),
                            height: 1.6,
                          ),
                        ),
                      ],
                      if (!compact) ...[
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _feature(
                              Icons.verified_user_outlined,
                              'Secure &\nReliable',
                            ),
                            const SizedBox(width: 28),
                            _feature(
                              Icons.insights_rounded,
                              'Data-Driven\nInsights',
                            ),
                            const SizedBox(width: 28),
                            _feature(
                              Icons.groups_outlined,
                              'Workforce\nExcellence',
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _feature(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: Colors.white70, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: const Color(0xFFCBD5E1),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  static Widget _ring(
    double size, {
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
