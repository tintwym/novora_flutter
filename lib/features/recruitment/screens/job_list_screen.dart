import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruitment'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Recruitment')),
    );
  }
}

typedef RecruitmentScreen = JobListScreen;
