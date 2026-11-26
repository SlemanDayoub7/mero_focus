import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/repositories/planner_preferences_repository_impl.dart';
import '../../data/repositories/subject_repository_impl.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_sort.dart';
import '../../domain/repositories/planner_preferences_repository.dart';
import '../../domain/repositories/subject_repository.dart';
import '../../domain/repositories/task_repository.dart';
import 'pomodoro_timer_controller.dart';
import 'subtasks_provider.dart';

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepositoryImpl(ref.watch(appDatabaseProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(ref.watch(appDatabaseProvider));
});

final plannerPreferencesRepositoryProvider =
    Provider<PlannerPreferencesRepository>((ref) {
      return PlannerPreferencesRepositoryImpl(ref.watch(appDatabaseProvider));
    });

final subjectsProvider = StreamProvider<List<Subject>>((ref) {
  return ref.watch(subjectRepositoryProvider).watchSubjects();
});

final tasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskRepositoryProvider).watchTasks();
});

final plannerPreferencesProvider = StreamProvider<PlannerPreferences>((ref) {
  return ref.watch(plannerPreferencesRepositoryProvider).watchPreferences();
});

final focusSessionsProvider = StreamProvider<List<FocusSession>>((ref) {
  return ref.watch(pomodoroRepositoryProvider).watchSessions();
});

final activeTaskIdProvider = NotifierProvider<ActiveTaskIdNotifier, int?>(
  ActiveTaskIdNotifier.new,
);

/// The task selected for the current focus session (UI-only state).
class ActiveTaskIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  /// Picking another task also drops the subtask of the previous one.
  void select(int? id) {
    state = id;
    ref.read(activeSubtaskIdProvider.notifier).select(null);
  }
}

final activeTaskProvider = Provider<Task?>((ref) {
  final id = ref.watch(activeTaskIdProvider);
  if (id == null) return null;
  final asyncTasks = ref.watch(tasksProvider);
  if (asyncTasks is! AsyncData<List<Task>>) return null;
  for (final task in asyncTasks.value) {
    if (task.id == id) return task;
  }
  return null;
});

final taskSortProvider = NotifierProvider<TaskSortNotifier, TaskSort>(
  TaskSortNotifier.new,
);

class TaskSortNotifier extends Notifier<TaskSort> {
  @override
  TaskSort build() => TaskSort.dueDate;

  void select(TaskSort sort) => state = sort;
}
