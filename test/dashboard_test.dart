import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:novora_flutter/core/storage/local_storage.dart';
import 'package:novora_flutter/features/dashboard/screens/dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  testWidgets('Dashboard screen builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DashboardScreen()),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
