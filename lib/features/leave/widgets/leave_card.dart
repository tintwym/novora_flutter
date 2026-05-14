import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class LeaveCard extends StatelessWidget {
  const LeaveCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: AppColors.navy),
        ),
      ),
    );
  }
}
