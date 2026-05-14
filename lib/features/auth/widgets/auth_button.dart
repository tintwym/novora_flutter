import 'package:flutter/material.dart';

import '../../../shared/widgets/app_button.dart';

/// Primary gradient CTA used on auth screens (aliases shared [AppButton] styling).
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
