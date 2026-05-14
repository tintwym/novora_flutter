import 'package:flutter_test/flutter_test.dart';

import 'package:novora_flutter/main.dart';

void main() {
  testWidgets('App boots to login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NovoraApp());
    await tester.pump();

    expect(find.textContaining('Novora'), findsWidgets);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
