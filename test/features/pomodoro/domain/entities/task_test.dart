import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/task.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/task_priority.dart';

void main() {
  test('effectiveDue falls back to the creation day', () {
    final created = DateTime(2026, 3, 1, 23, 30);
    final task = Task(title: 'Read', createdAt: created);

    expect(task.effectiveDue, DateTime(2026, 3, 1));
  });

  test('copyWith can clear optional references and timestamps', () {
    final created = DateTime(2026, 3, 1, 9);
    final task = Task(
      id: 7,
      title: 'Read',
      createdAt: created,
      subjectId: 3,
      priority: TaskPriority.high,
      dueDate: created.add(const Duration(days: 1)),
      completedAt: created.add(const Duration(hours: 1)),
    );

    final cleared = task.copyWith(
      clearSubject: true,
      clearDueDate: true,
      clearCompletedAt: true,
    );

    expect(cleared.id, 7);
    expect(cleared.subjectId, isNull);
    expect(cleared.dueDate, isNull);
    expect(cleared.completedAt, isNull);
    expect(cleared.priority, TaskPriority.high);
  });
}
