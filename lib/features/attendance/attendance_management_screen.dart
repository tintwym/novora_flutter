import 'package:flutter/material.dart';

import 'screens/attendance_screen.dart';

/// Route-friendly wrapper around [AttendanceScreen].
class AttendanceManagementScreen extends StatelessWidget {
  const AttendanceManagementScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) =>
      AttendanceScreen(embeddedInShell: embeddedInShell);
}
