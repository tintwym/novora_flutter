import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/features/claim_management/screens/claim_management_screen.dart';

void main() {
  testWidgets('Claim management admin shows six tabs and approval table', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1400, 900));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClaimManagementScreen(embeddedInShell: true, employeeView: false),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('CLAIM MANAGEMENT'), findsOneWidget);
    expect(find.text('Policy & compliance'), findsOneWidget);

    await tester.tap(find.text('Approval'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sarah Lim'), findsOneWidget);

    await tester.tap(find.text('Claim history'));
    await tester.pumpAndSettle();
    expect(find.text('Generate PDF'), findsOneWidget);
  });

  testWidgets('Claim management employee shows two tabs', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(900, 800));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClaimManagementScreen(embeddedInShell: true, employeeView: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Submit claim'), findsWidgets);
    expect(find.text('Claim history'), findsWidgets);
    expect(find.text('Policy & compliance'), findsNothing);
  });
}
