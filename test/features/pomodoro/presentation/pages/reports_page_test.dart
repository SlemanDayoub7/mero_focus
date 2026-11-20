import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/pomodoro/data/repositories/pomodoro_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/focus_session.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/session_type.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/reports_page.dart';

import '../../helpers/planner_test_helpers.dart';

void main() {
  late PlannerTestHarness harness;

  setUp(() async {
    harness = await PlannerTestHarness.create();
  });

  tearDown(() => harness.dispose());

  /// The report has many tiles above the range selector and records list;
  /// use a tall surface so every assertion target is built.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> seedSession() async {
    final now = DateTime.now();
    await PomodoroRepositoryImpl(harness.database).saveSession(
      FocusSession(
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now.subtract(const Duration(hours: 1, minutes: 25)),
        plannedDuration: const Duration(minutes: 25),
        actualDuration: const Duration(minutes: 25),
        sessionType: SessionType.work,
        label: 'Math',
      ),
    );
  }

  testWidgets('renders localized report summary and session records', (
    tester,
  ) async {
    useTallSurface(tester);
    await seedSession();
    await harness.pumpPage(tester, const ReportsPage());

    expect(find.text('Reports'), findsWidgets);
    expect(find.text('Pomodoro report'), findsOneWidget);
    expect(find.text('Tasks report'), findsOneWidget);
    expect(find.text('Total focus time'), findsOneWidget);
    expect(find.text('Completed focus sessions'), findsOneWidget);
    expect(find.text('Records'), findsOneWidget);
    expect(find.text('Math'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
  });

  testWidgets('switches the range with the segmented button', (tester) async {
    useTallSurface(tester);
    await seedSession();
    await harness.pumpPage(tester, const ReportsPage());

    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();

    expect(find.text('Monthly'), findsOneWidget);
  });

  testWidgets('uses Arabic labels when the locale is Arabic', (tester) async {
    useTallSurface(tester);
    await harness.pumpPage(
      tester,
      const ReportsPage(),
      locale: const Locale('ar'),
    );

    expect(find.text('التقارير'), findsWidgets);
    expect(find.text('تقرير البومودورو'), findsOneWidget);
    expect(find.text('أسبوعي'), findsOneWidget);
  });
}
