import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PayrollCard extends StatelessWidget {
  const PayrollCard({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(color: AppColors.navy)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}
