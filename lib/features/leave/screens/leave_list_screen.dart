import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class LeaveListScreen extends StatelessWidget {
  const LeaveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Leave')),
    );
  }
}

typedef LeaveScreen = LeaveListScreen;
