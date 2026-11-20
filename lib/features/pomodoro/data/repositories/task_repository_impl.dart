import 'package:drift/drift.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;

import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/repositories/task_repository.dart';

/// Drift-backed implementation of the planner-task port.
class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Task>> watchTasks() {
    final query = _database.select(_database.tasks)
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);
    return query.watch().map(
      (rows) => rows.map(_toEntity).toList(growable: false),
    );
  }

  @override
  Future<int> addTask(Task task) {
    return _database
        .into(_database.tasks)
        .insert(_toCompanion(task, includeId: false));
  }

  @override
  Future<void> updateTask(Task task) async {
    final id = task.id;
    if (id == null) return;
    await (_database.update(
      _database.tasks,
    )..where((row) => row.id.equals(id))).write(_toCompanion(task));
  }

  @override
  Future<void> removeTask(int id) async {
    await _database.transaction(() async {
      // Keep historical sessions but drop the dangling task reference.
      await (_database.update(_database.focusSessions)
            ..where((row) => row.taskId.equals(id)))
          .write(const db.FocusSessionsCompanion(taskId: Value<int?>(null)));
      await (_database.delete(
        _database.tasks,
      )..where((row) => row.id.equals(id))).go();
    });
  }

  db.TasksCompanion _toCompanion(Task task, {bool includeId = true}) {
    return db.TasksCompanion(
      id: includeId && task.id != null ? Value(task.id!) : const Value.absent(),
      title: Value(task.title),
      createdAt: Value(task.createdAt),
      subjectId: Value(task.subjectId),
      priority: Value(task.priority.storageValue),
      dueDate: Value(task.dueDate),
      estimatedPomodoros: Value(task.estimatedPomodoros),
      done: Value(task.done),
      completedAt: Value(task.completedAt),
    );
  }

  Task _toEntity(db.Task row) => Task(
    id: row.id,
    title: row.title,
    createdAt: row.createdAt,
    subjectId: row.subjectId,
    priority: TaskPriority.fromStorage(row.priority),
    dueDate: row.dueDate,
    estimatedPomodoros: row.estimatedPomodoros,
    done: row.done,
    completedAt: row.completedAt,
  );
}
