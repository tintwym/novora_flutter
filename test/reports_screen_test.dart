import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/features/reports/screens/reports_screen.dart';

void main() {
  testWidgets('Reports screen shows report centre', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1200, 800));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ReportsScreen(embeddedInShell: true)),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('All reports across every HRMS module in one place.'),
      findsOneWidget,
    );
    expect(find.text('Most used reports'), findsOneWidget);
    expect(find.text('Monthly payroll summary'), findsWidgets);
  });

  testWidgets('narrow layout shows Sections drawer control', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(900, 800));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ReportsScreen(embeddedInShell: true)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sections'), findsOneWidget);
  });

  testWidgets('wide content area shows pinned secondary sidebar', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1600, 800));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ReportsScreen(embeddedInShell: true)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sections'), findsNothing);

    await tester.tap(find.text('+ Schedule'));
    await tester.pumpAndSettle();

    expect(find.text('New scheduled report'), findsOneWidget);
  });

  testWidgets('shell mode uses main sidebar subnav only', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1400, 800));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SizedBox(width: 242),
              Expanded(
                child: ReportsScreen(
                  embeddedInShell: true,
                  showSecondaryNav: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sections'), findsNothing);
    expect(find.text('OVERVIEW'), findsNothing);
  });

  testWidgets('Sections drawer navigates on narrow layout', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(900, 800));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ReportsScreen(embeddedInShell: true)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sections'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Custom builder'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 — Data source'), findsOneWidget);
  });
}
