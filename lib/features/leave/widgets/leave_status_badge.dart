import 'package:flutter/material.dart';

import '../../../shared/widgets/status_badge.dart';

/// Leave-specific status chip (reuses shared [StatusBadge]).
class LeaveStatusBadge extends StatelessWidget {
  const LeaveStatusBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => StatusBadge(label: label);
}
