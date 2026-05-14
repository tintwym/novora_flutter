import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class LeaveCalendarScreen extends StatelessWidget {
  const LeaveCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave calendar'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Leave calendar')),
    );
  }
}
