import 'package:flutter/material.dart';

/// Desktop shell: fixed sidebar + scrollable main column ([topBar] + [body]).
class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.sidebar,
    required this.topBar,
    required this.body,
  });

  final Widget sidebar;
  final Widget topBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sidebar,
        Expanded(
          child: Column(
            children: [
              topBar,
              Expanded(child: body),
            ],
          ),
        ),
      ],
    );
  }
}
