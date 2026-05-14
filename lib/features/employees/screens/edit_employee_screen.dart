import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class EditEmployeeScreen extends StatelessWidget {
  const EditEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit employee'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Edit employee')),
    );
  }
}
