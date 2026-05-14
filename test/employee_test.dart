import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:novora_flutter/features/employees/screens/employee_list_screen.dart';

void main() {
  testWidgets('Employee list screen builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: EmployeeListScreen()),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
