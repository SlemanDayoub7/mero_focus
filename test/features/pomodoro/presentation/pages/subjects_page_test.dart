import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/pomodoro/data/repositories/subject_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/subject.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/subjects_page.dart';

import '../../helpers/planner_test_helpers.dart';

void main() {
  late PlannerTestHarness harness;

  setUp(() async {
    harness = await PlannerTestHarness.create();
  });

  tearDown(() => harness.dispose());

  testWidgets('lists seeded subjects', (tester) async {
    await SubjectRepositoryImpl(
      harness.database,
    ).addSubject(const Subject(name: 'Physics', colorHex: 'FF42A5F5'));

    await harness.pumpPage(tester, const SubjectsPage());

    expect(find.text('Subjects'), findsWidgets);
    expect(find.text('Physics'), findsOneWidget);
  });

  testWidgets('adds a subject through the editor sheet', (tester) async {
    await harness.pumpPage(tester, const SubjectsPage());
    expect(find.text('Add your subjects to pick them later'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('New subject'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Chemistry');
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();

    expect(find.text('Chemistry'), findsOneWidget);
    expect(find.text('Add your subjects to pick them later'), findsNothing);
  });

  testWidgets('uses Arabic labels when the locale is Arabic', (tester) async {
    await harness.pumpPage(
      tester,
      const SubjectsPage(),
      locale: const Locale('ar'),
    );

    expect(find.text('المواد الدراسية'), findsWidgets);
    expect(find.text('أضف موادك ليسهل اختيارها لاحقاً'), findsOneWidget);
  });
}
