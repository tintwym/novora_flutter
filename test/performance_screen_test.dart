import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/features/performance/screens/performance_screen.dart';

void main() {
  testWidgets('Performance module shows header, tables, and evaluation entry', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1400, 900));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PerformanceScreen(embeddedInShell: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Perf. level'), findsOneWidget);
    expect(find.text('Basic'), findsOneWidget);

    await tester.tap(find.text('Perf. grade'));
    await tester.pumpAndSettle();
    expect(find.text('Excellent'), findsOneWidget);

    final evalTab = find.text('Evaluation');
    await tester.ensureVisible(evalTab);
    await tester.pumpAndSettle();
    await tester.tap(evalTab);
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ New evaluation').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Evaluation entry'), findsOneWidget);
    expect(find.byKey(const Key('perf_eval_back')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('perf_eval_back')));
    await tester.tap(find.byKey(const Key('perf_eval_back')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('perf_eval_back')), findsNothing);
    expect(find.text('Search employee...'), findsOneWidget);
  });
}
