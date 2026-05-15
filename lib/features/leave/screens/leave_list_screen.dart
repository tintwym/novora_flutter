import 'package:flutter/material.dart';

import 'leave_management_screen.dart';

/// Shell route / dashboard entry — delegates to [LeaveManagementScreen].
class LeaveListScreen extends StatelessWidget {
  const LeaveListScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    return LeaveManagementScreen(embeddedInShell: embeddedInShell);
  }
}

typedef LeaveScreen = LeaveListScreen;
