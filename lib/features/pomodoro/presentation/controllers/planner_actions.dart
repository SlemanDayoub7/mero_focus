import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/planner_preferences_repository.dart';
import '../../domain/repositories/subject_repository.dart';
import '../../domain/repositories/task_repository.dart';
import 'planner_providers.dart';

/// User intents for the planner screens. Keeps widgets free of repository
/// details and gives tests a single provider to override if needed.
final plannerActionsProvider = Provider<PlannerActions>((ref) {
  return PlannerActions(
    subjects: ref.watch(subjectRepositoryProvider),
    tasks: ref.watch(taskRepositoryProvider),
    preferences: ref.watch(plannerPreferencesRepositoryProvider),
  );
});

class PlannerActions {
  const PlannerActions({
    required this.subjects,
    required this.tasks,
    required this.preferences,
  });

  final SubjectRepository subjects;
  final TaskRepository tasks;
  final PlannerPreferencesRepository preferences;

  Future<int> addSubject(String rawName, String colorHex) {
    final name = rawName.trim();
    if (name.isEmpty) {
      return Future.error(
        ArgumentError.value(rawName, 'name', 'must not be empty'),
      );
    }
    return subjects.addSubject(Subject(name: name, colorHex: colorHex));
  }

  Future<void> removeSubject(int id) => subjects.removeSubject(id);

  Future<int> addTask(Task task) => tasks.addTask(task);

  Future<void> updateTask(Task task) => tasks.updateTask(task);

  Future<void> removeTask(int id) => tasks.removeTask(id);

  Future<void> setTaskDone(Task task, {required bool done}) {
    return tasks.updateTask(
      task.copyWith(
        done: done,
        completedAt: done ? DateTime.now() : null,
        clearCompletedAt: !done,
      ),
    );
  }

  Future<void> savePreferences(PlannerPreferences value) =>
      preferences.savePreferences(value);
}
