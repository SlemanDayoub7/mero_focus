import '../entities/task.dart';

/// Persistence port for planner tasks (ADR-0005).
abstract class TaskRepository {
  Stream<List<Task>> watchTasks();

  Future<int> addTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> removeTask(int id);
}
