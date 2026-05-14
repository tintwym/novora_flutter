import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key, required this.name, this.role});

  final String name;
  final String? role;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(color: AppColors.navy),
        ),
        subtitle: role != null ? Text(role!) : null,
      ),
    );
  }
}
