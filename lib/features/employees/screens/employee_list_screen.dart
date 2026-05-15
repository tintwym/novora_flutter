import 'package:flutter/material.dart';

import '../../employment/employment_management_screen.dart';

/// Employee directory list (uses employment module implementation).
class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) =>
      EmploymentManagementScreen(embeddedInShell: embeddedInShell);
}
