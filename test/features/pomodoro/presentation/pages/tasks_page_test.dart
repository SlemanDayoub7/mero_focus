import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/pomodoro/data/repositories/subject_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/data/repositories/task_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/subject.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/task.dart';
import 'package:mero_focus/features/pomodoro/presentation/pages/tasks_page.dart';

import '../../helpers/planner_test_helpers.dart';

void main() {
  late PlannerTestHarness harness;

  setUp(() async {
    harness = await PlannerTestHarness.create();
  });

  tearDown(() => harness.dispose());

  Future<void> seed() async {
    final subjects = SubjectRepositoryImpl(harness.database);
    final tasks = TaskRepositoryImpl(harness.database);
    final now = DateTime.now();

    final subjectId = await subjects.addSubject(
      const Subject(name: 'Math', colorHex: 'FF26A69A'),
    );
    await tasks.addTask(
      Task(
        title: 'Read chapter 1',
        createdAt: now,
        subjectId: subjectId,
        estimatedPomodoros: 2,
      ),
    );
    await tasks.addTask(
      Task(
        title: 'Done yesterday',
        createdAt: now.subtract(const Duration(days: 1)),
        done: true,
        completedAt: now.subtract(const Duration(hours: 2)),
      ),
    );
  }

  testWidgets('renders localized tabs, summaries and today tasks', (
    tester,
  ) async {
    await seed();
    await harness.pumpPage(tester, const TasksPage());

    expect(find.text('Tasks'), findsWidgets);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('Read chapter 1'), findsOneWidget);
    expect(find.text('Done yesterday'), findsNothing);
    expect(find.text('Math'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
  });

  testWidgets('quick-add creates a task for the selected scope', (
    tester,
  ) async {
    await seed();
    await harness.pumpPage(tester, const TasksPage());

    final field = find.byType(TextField);
    expect(field, findsOneWidget);
    await tester.enterText(field, 'New quick task');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('New quick task'), findsOneWidget);
  });

  testWidgets('uses Arabic labels when the locale is Arabic', (tester) async {
    await seed();
    await harness.pumpPage(
      tester,
      const TasksPage(),
      locale: const Locale('ar'),
    );

    expect(find.text('المهام'), findsWidgets);
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('غداً'), findsOneWidget);
    expect(find.text('هذا الأسبوع'), findsOneWidget);
  });
}
