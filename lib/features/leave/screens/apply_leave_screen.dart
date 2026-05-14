import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ApplyLeaveScreen extends StatelessWidget {
  const ApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply leave'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Apply leave')),
    );
  }
}
