import 'package:flutter/material.dart';

import '../training_management_screen.dart';

/// Primary training hub (backed by the full management UI).
class TrainingListScreen extends StatelessWidget {
  const TrainingListScreen({super.key});

  @override
  Widget build(BuildContext context) => const TrainingManagementScreen();
}
