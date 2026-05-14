import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ApplicantScreen extends StatelessWidget {
  const ApplicantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicants'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Applicants')),
    );
  }
}
