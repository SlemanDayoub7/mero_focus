import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;
import 'package:mero_focus/features/pomodoro/data/repositories/task_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/task.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/task_priority.dart';

void main() {
  test('tasks are persisted, updated and unlinked from old sessions', () async {
    final database = db.AppDatabase.forTesting();
    addTearDown(database.close);
    final repository = TaskRepositoryImpl(database);
    final created = DateTime(2026, 3, 1, 9);

    final id = await repository.addTask(
      Task(
        title: 'Read chapter 1',
        createdAt: created,
        priority: TaskPriority.high,
        dueDate: created.add(const Duration(days: 1)),
        estimatedPomodoros: 3,
      ),
    );

    var tasks = await repository.watchTasks().first;
    expect(tasks, hasLength(1));
    expect(tasks.single.id, id);
    expect(tasks.single.title, 'Read chapter 1');
    expect(tasks.single.priority, TaskPriority.high);
    expect(tasks.single.estimatedPomodoros, 3);

    await repository.updateTask(
      Task(
        id: id,
        title: 'Read chapter 2',
        createdAt: created,
        priority: TaskPriority.low,
        done: true,
        completedAt: created.add(const Duration(hours: 1)),
      ),
    );

    tasks = await repository.watchTasks().first;
    expect(tasks.single.title, 'Read chapter 2');
    expect(tasks.single.priority, TaskPriority.low);
    expect(tasks.single.done, isTrue);
    expect(tasks.single.completedAt, created.add(const Duration(hours: 1)));

    await database
        .into(database.focusSessions)
        .insert(
          db.FocusSessionsCompanion.insert(
            startTime: created,
            plannedDurationSeconds: 1500,
            actualDurationSeconds: 1500,
            sessionType: 0,
            taskId: drift.Value(id),
          ),
        );

    await repository.removeTask(id);

    expect(await repository.watchTasks().first, isEmpty);
    final session =
        (await database.select(database.focusSessions).get()).single;
    expect(session.taskId, isNull);
  });
}
