import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/routing/app_router.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/done_tasks_page.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/reports_page.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/subjects_page.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/tasks_page.dart';
import 'package:mero_focus/l10n/app_localizations.dart';

import '../../features/pomodoro/helpers/planner_test_helpers.dart';

void main() {
  late PlannerTestHarness harness;

  setUp(() async {
    harness = await PlannerTestHarness.create();
  });

  tearDown(() => harness.dispose());

  Future<BuildContext> pumpRouter(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: harness.container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          routes: Map<String, WidgetBuilder>.fromEntries(
            AppRouter.routes.entries.where(
              (entry) => entry.key != AppRouter.home,
            ),
          ),
          home: const SizedBox.shrink(key: Key('home')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.element(find.byKey(const Key('home')));
  }

  testWidgets('toTasks opens the tasks page', (tester) async {
    final context = await pumpRouter(tester);
    AppRouter.toTasks(context);
    await tester.pumpAndSettle();
    expect(find.byType(TasksPage), findsOneWidget);
  });

  testWidgets('toSubjects opens the subjects page', (tester) async {
    final context = await pumpRouter(tester);
    AppRouter.toSubjects(context);
    await tester.pumpAndSettle();
    expect(find.byType(SubjectsPage), findsOneWidget);
  });

  testWidgets('toReports opens the reports page', (tester) async {
    final context = await pumpRouter(tester);
    AppRouter.toReports(context);
    await tester.pumpAndSettle();
    expect(find.byType(ReportsPage), findsOneWidget);
  });

  testWidgets('toDoneTasks opens the completed tasks page', (tester) async {
    final context = await pumpRouter(tester);
    AppRouter.toDoneTasks(context);
    await tester.pumpAndSettle();
    expect(find.byType(DoneTasksPage), findsOneWidget);
  });
}
