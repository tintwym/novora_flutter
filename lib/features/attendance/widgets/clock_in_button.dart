import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Primary clock-in action (placeholder).
class ClockInButton extends StatelessWidget {
  const ClockInButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.schedule_rounded),
      label: const Text('Clock in'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
