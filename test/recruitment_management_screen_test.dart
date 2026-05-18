import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/features/recruitment/screens/recruitment_management_screen.dart';

void main() {
  testWidgets('Recruitment management shows seven tabs and pipeline', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1400, 900));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RecruitmentManagementScreen(embeddedInShell: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('RECRUITMENT MANAGEMENT'), findsOneWidget);
    expect(find.text('+ New requisition'), findsWidgets);
    expect(find.text('Job requisition'), findsOneWidget);
    expect(find.text('Candidate pipeline'), findsOneWidget);

    await tester.tap(find.text('Candidate pipeline'));
    await tester.pumpAndSettle();
    expect(find.text('Aisha Rahman'), findsOneWidget);
    expect(find.text('Applied'), findsOneWidget);

    await tester.tap(find.text('Interviews'));
    await tester.pumpAndSettle();
    expect(find.text('Schedule interview'), findsOneWidget);
    expect(find.text('Lena Wong'), findsWidgets);

    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Pipeline conversion rate'), findsOneWidget);
    expect(find.text('Generate PDF'), findsOneWidget);
  });
}
