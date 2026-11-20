import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/stat_range.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_sort.dart';
import '../../domain/stats/pomodoro_stats.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../formatting/duration_labels.dart';
import '../sheets/add_task_field.dart';
import '../sheets/task_edit_sheet.dart';
import '../widgets/planner_stat_tile.dart';
import '../widgets/task_tile.dart';

enum _Scope { today, tomorrow, week }

/// Today / Tomorrow / This week planner with a sort menu and drawer shortcuts.
class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sort = ref.watch(taskSortProvider);

    return DefaultTabController(
      length: 3,
      child: AppScaffold(
        appBar: AppAppBar(
          title: l10n.tasks,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tasksToday),
              Tab(text: l10n.tasksTomorrow),
              Tab(text: l10n.tasksWeek),
            ],
          ),
          actions: [
            PopupMenuButton<TaskSort>(
              tooltip: l10n.tasksSort,
              icon: const Icon(Icons.sort),
              onSelected: ref.read(taskSortProvider.notifier).select,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: TaskSort.project,
                  child: Text(l10n.tasksSortProject),
                ),
                PopupMenuItem(
                  value: TaskSort.dueDate,
                  child: Text(l10n.tasksSortDueDate),
                ),
                PopupMenuItem(
                  value: TaskSort.priority,
                  child: Text(l10n.tasksSortPriority),
                ),
              ],
            ),
            IconButton(
              tooltip: l10n.reports,
              icon: const Icon(Icons.bar_chart_outlined),
              onPressed: () => AppRouter.toReports(context),
            ),
          ],
        ),
        drawer: const _TasksDrawer(),
        body: TabBarView(
          children: [
            _TaskScope(scope: _Scope.today, sort: sort),
            _TaskScope(scope: _Scope.tomorrow, sort: sort),
            _TaskScope(scope: _Scope.week, sort: sort),
          ],
        ),
      ),
    );
  }
}

class _TasksDrawer extends StatelessWidget {
  const _TasksDrawer();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: Text(l10n.subjects),
              onTap: () {
                Navigator.pop(context);
                unawaited(AppRouter.toSubjects(context));
              },
            ),
            ListTile(
              leading: const Icon(Icons.done_all),
              title: Text(l10n.tasksDone),
              onTap: () {
                Navigator.pop(context);
                unawaited(AppRouter.toDoneTasks(context));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: Text(l10n.reports),
              onTap: () {
                Navigator.pop(context);
                unawaited(AppRouter.toReports(context));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskScope extends ConsumerStatefulWidget {
  const _TaskScope({required this.scope, required this.sort});

  final _Scope scope;
  final TaskSort sort;

  @override
  ConsumerState<_TaskScope> createState() => _TaskScopeState();
}

class _TaskScopeState extends ConsumerState<_TaskScope> {
  bool _showDone = false;

  ({DateTime from, DateTime to}) _window(DateTime now) {
    final today = startOfDay(now);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return switch (widget.scope) {
      _Scope.today => (from: today, to: tomorrow),
      _Scope.tomorrow => (
        from: tomorrow,
        to: DateTime(now.year, now.month, now.day + 2),
      ),
      _Scope.week => windowFor(StatRange.week, now),
    };
  }

  String _subjectName(Task task, List<Subject> subjects) {
    for (final subject in subjects) {
      if (subject.id == task.subjectId) return subject.name;
    }
    return '';
  }

  List<Task> _sorted(List<Task> source, List<Subject> subjects, TaskSort sort) {
    final result = [...source];
    switch (sort) {
      case TaskSort.project:
        result.sort(
          (a, b) =>
              _subjectName(a, subjects).compareTo(_subjectName(b, subjects)),
        );
      case TaskSort.dueDate:
        result.sort((a, b) => a.effectiveDue.compareTo(b.effectiveDue));
      case TaskSort.priority:
        result.sort(
          (a, b) => b.priority.storageValue.compareTo(a.priority.storageValue),
        );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final window = _window(now);
    final tasksAsync = ref.watch(tasksProvider);
    final subjectsAsync = ref.watch(subjectsProvider);
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final preferencesAsync = ref.watch(plannerPreferencesProvider);

    if (tasksAsync is! AsyncData<List<Task>> ||
        subjectsAsync is! AsyncData<List<Subject>> ||
        sessionsAsync is! AsyncData<List<FocusSession>>) {
      return const Center(child: CircularProgressIndicator());
    }

    final tasks = tasksAsync.value;
    final subjects = subjectsAsync.value;
    final preferences = preferencesAsync is AsyncData<PlannerPreferences>
        ? preferencesAsync.value
        : const PlannerPreferences();
    final stats = PomodoroStats(
      sessionsAsync.value,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );

    bool inScope(Task task) {
      final due = task.effectiveDue;
      return widget.scope == _Scope.today
          ? due.isBefore(window.to)
          : !due.isBefore(window.from) && due.isBefore(window.to);
    }

    final pending = tasks.where((task) => !task.done && inScope(task)).toList();
    final done = tasks
        .where(
          (task) =>
              task.done &&
              task.completedAt != null &&
              !task.completedAt!.isBefore(window.from) &&
              task.completedAt!.isBefore(window.to),
        )
        .toList();
    final visible = _sorted(
      [...pending, if (_showDone) ...done],
      subjects,
      widget.sort,
    );
    final estimatedSeconds = pending.fold<int>(
      0,
      (sum, task) =>
          sum + task.estimatedPomodoros * preferences.focusDuration.inSeconds,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              if (widget.scope != _Scope.tomorrow)
                Expanded(
                  child: PlannerStatTile(
                    label: l10n.tasksCompletedCount,
                    value: '${done.length}',
                  ),
                ),
              if (widget.scope != _Scope.tomorrow)
                Expanded(
                  child: PlannerStatTile(
                    label: l10n.tasksElapsedTime,
                    value: stats
                        .totalDuration(window.from, window.to)
                        .labelOf(context),
                  ),
                ),
              Expanded(
                child: PlannerStatTile(
                  label: l10n.tasksRemainingCount,
                  value: '${pending.length}',
                ),
              ),
              Expanded(
                child: PlannerStatTile(
                  label: l10n.tasksEstimatedTime,
                  value: Duration(seconds: estimatedSeconds).labelOf(context),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: AddTaskField(
            due: widget.scope == _Scope.tomorrow
                ? window.from
                : startOfDay(now),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: visible.isEmpty
              ? Center(child: Text(l10n.tasksEmpty))
              : ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final task = visible[index];
                    return TaskTile(
                      task: task,
                      subjects: subjects,
                      onToggleDone: () => ref
                          .read(plannerActionsProvider)
                          .setTaskDone(task, done: !task.done),
                      onDelete: () {
                        final id = task.id;
                        if (id == null) return;
                        unawaited(
                          ref.read(plannerActionsProvider).removeTask(id).then((
                            _,
                          ) {
                            if (ref.read(activeTaskIdProvider) == id) {
                              ref
                                  .read(activeTaskIdProvider.notifier)
                                  .select(null);
                            }
                          }),
                        );
                      },
                      onEdit: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => TaskEditSheet(task: task),
                      ),
                      onStartFocus: task.id == null
                          ? null
                          : () {
                              ref
                                  .read(activeTaskIdProvider.notifier)
                                  .select(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.tasksSelected)),
                              );
                            },
                    );
                  },
                ),
        ),
        if (widget.scope == _Scope.week)
          TextButton.icon(
            onPressed: () => setState(() => _showDone = !_showDone),
            icon: Icon(_showDone ? Icons.visibility_off : Icons.visibility),
            label: Text(_showDone ? l10n.tasksHideDone : l10n.tasksShowDone),
          ),
      ],
    );
  }
}
