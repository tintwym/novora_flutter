import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/features/asset_management/screens/asset_management_screen.dart';

void main() {
  testWidgets('Asset registry shows table and register flow', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1400, 900));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AssetManagementScreen(embeddedInShell: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('ASSET MANAGEMENT'), findsOneWidget);
    expect(find.text('MacBook Pro 14"'), findsOneWidget);
    expect(find.text('AST-IT-0021'), findsOneWidget);

    await tester.tap(find.text('+ Register asset').first);
    await tester.pumpAndSettle();

    expect(find.text('Register asset'), findsWidgets);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Test Laptop');
    await tester.enterText(fields.at(1), 'AST-IT-9999');
    await tester.tap(find.text('Save to registry'));
    await tester.pumpAndSettle();

    expect(find.text('Test Laptop'), findsOneWidget);
    expect(find.text('AST-IT-9999'), findsOneWidget);
  });
}
