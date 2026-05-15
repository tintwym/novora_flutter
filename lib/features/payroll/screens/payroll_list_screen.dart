import 'package:flutter/material.dart';

import 'payroll_management_screen.dart';

/// Dashboard / route entry — delegates to [PayrollManagementScreen].
class PayrollListScreen extends StatelessWidget {
  const PayrollListScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    return PayrollManagementScreen(embeddedInShell: embeddedInShell);
  }
}

typedef PayrollScreen = PayrollListScreen;
