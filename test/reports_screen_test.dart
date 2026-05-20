import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/features/reports/screens/reports_screen.dart';

void main() {
  testWidgets('Reports screen shows Novora Reports Center', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1400, 900));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ReportsScreen(embeddedInShell: true)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Novora Reports Center'), findsOneWidget);
    expect(
      find.text(
        'Insights, analytics, and auto-generated data exports across all modules.',
      ),
      findsOneWidget,
    );
    expect(find.text('All Overview'), findsOneWidget);
    expect(find.text('MOST USED REPORTS'), findsOneWidget);
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

  testWidgets('switching tabs renders module body', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1600, 900));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ReportsScreen(embeddedInShell: true)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Payroll'));
    await tester.pumpAndSettle();

    expect(find.text('PAY REPORTS AVAILABLE'), findsOneWidget);
    expect(find.text('Pay Summary'), findsOneWidget);
    expect(find.text('QUICK SNAPSHOT'), findsOneWidget);
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
    expect(find.text('Novora Reports Center'), findsOneWidget);
  });

  testWidgets('Sections drawer navigates to Custom builder', (tester) async {
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

    expect(find.text('1. DATA SOURCE'), findsOneWidget);
    expect(find.text('Run & Export Report'), findsOneWidget);
  });
}
