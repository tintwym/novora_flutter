import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class EmployeeFilterBar extends StatelessWidget {
  const EmployeeFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: const Row(
        children: [
          Icon(Icons.filter_list_rounded, size: 18),
          SizedBox(width: 8),
          Text('Filters'),
        ],
      ),
    );
  }
}
