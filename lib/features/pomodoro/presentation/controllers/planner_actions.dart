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

  Future<void> updateSubject(Subject subject) {
    final name = subject.name.trim();
    if (name.isEmpty) {
      return Future.error(
        ArgumentError.value(subject.name, 'name', 'must not be empty'),
      );
    }
    return subjects.updateSubject(subject.copyWith(name: name));
  }

  Future<void> removeSubject(int id) => subjects.removeSubject(id);

  /// Tapping a subject adds ONE task for today, named after the subject.
  /// Tapping again on the same day reuses that task (re-opening it if it was
  /// completed). On another day the user must tap again to get a new task.
  Future<int> taskForSubject(Subject subject) async {
    final all = await tasks.watchTasks().first;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final task in all) {
      final id = task.id;
      if (id == null ||
          task.subjectId != subject.id ||
          task.title != subject.name) {
        continue;
      }
      final due = task.effectiveDue;
      if (due.year == today.year &&
          due.month == today.month &&
          due.day == today.day) {
        if (task.done) await setTaskDone(task, done: false);
        return id;
      }
    }
    return tasks.addTask(
      Task(
        title: subject.name,
        createdAt: now,
        dueDate: today,
        subjectId: subject.id,
      ),
    );
  }

  /// True for a task created by tapping a subject (same name, same subject).
  static bool isSubjectDailyTask(Task task, List<Subject> subjects) {
    final subjectId = task.subjectId;
    if (subjectId == null) return false;
    for (final subject in subjects) {
      if (subject.id == subjectId) return subject.name == task.title;
    }
    return false;
  }

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
