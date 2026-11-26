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
import '../controllers/focus_totals.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../sheets/add_task_field.dart';
import '../sheets/task_edit_sheet.dart';
import '../widgets/subjects_strip.dart';
import '../widgets/task_tile.dart';
import '../widgets/tasks_summary_card.dart';
import 'focus_launcher.dart';
import 'reminders_page.dart';

enum _Scope { today, tomorrow, week }

/// Subjects strip + Today / Tomorrow / This week planner.
class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sort = ref.watch(taskSortProvider);

    return DefaultTabController(
      length: 3,
      child: AppScaffold(
        transparentBackground: true,
        appBar: AppAppBar(
          title: l10n.tasks,
          transparentDegree: 0.7,
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
        body: Column(
          children: [
            //     const GoalsCard(),
            const SubjectsStrip(),
            Expanded(
              child: TabBarView(
                children: [
                  _TaskScope(scope: _Scope.today, sort: sort),
                  _TaskScope(scope: _Scope.tomorrow, sort: sort),
                  _TaskScope(scope: _Scope.week, sort: sort),
                ],
              ),
            ),
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
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text(l10n.reminders),
              onTap: () {
                final navigator = Navigator.of(context);
                navigator.pop();
                unawaited(
                  navigator.push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const RemindersPage(),
                    ),
                  ),
                );
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

  /// Dart's sort is not guaranteed stable, so every comparison falls back to
  /// due date and creation time to keep the order deterministic.
  List<Task> _sorted(List<Task> source, List<Subject> subjects, TaskSort sort) {
    int tieBreak(Task a, Task b) {
      final byDue = a.effectiveDue.compareTo(b.effectiveDue);
      return byDue != 0 ? byDue : a.createdAt.compareTo(b.createdAt);
    }

    final result = [...source];
    switch (sort) {
      case TaskSort.project:
        result.sort((a, b) {
          final bySubject = _subjectName(
            a,
            subjects,
          ).compareTo(_subjectName(b, subjects));
          return bySubject != 0 ? bySubject : tieBreak(a, b);
        });
      case TaskSort.dueDate:
        result.sort(tieBreak);
      case TaskSort.priority:
        result.sort((a, b) {
          final byPriority = b.priority.storageValue.compareTo(
            a.priority.storageValue,
          );
          return byPriority != 0 ? byPriority : tieBreak(a, b);
        });
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
        sessionsAsync is! AsyncData<List<FocusSession>> ||
        preferencesAsync is! AsyncData<PlannerPreferences>) {
      return const Center(child: CircularProgressIndicator());
    }

    final tasks = tasksAsync.value;
    final subjects = subjectsAsync.value;
    final taskTotals = ref.watch(taskTotalsProvider);
    final preferences = preferencesAsync.value;
    final stats = PomodoroStats(
      sessionsAsync.value,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );

    bool inScope(Task task) {
      final due = task.effectiveDue;
      if (widget.scope == _Scope.today) {
        // A subject's daily task only belongs to the day it was added; a
        // stale one must not pile up in later days.
        if (PlannerActions.isSubjectDailyTask(task, subjects)) {
          return !due.isBefore(window.from) && due.isBefore(window.to);
        }
        return due.isBefore(window.to);
      }
      return !due.isBefore(window.from) && due.isBefore(window.to);
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
        TasksSummaryCard(
          estimated: Duration(seconds: estimatedSeconds),
          toDo: pending.length,
          elapsed: stats.totalDuration(window.from, window.to),
          completed: done.length,
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
                      total:
                          (task.id == null ? null : taskTotals[task.id!]) ??
                          const FocusTotal(),
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
                      // Play: select the task, start the timer and jump to
                      // the Pomodoro screen.
                      onStartFocus: task.id == null || task.done
                          ? null
                          : () => unawaited(
                              startFocusOnTask(context, ref, task.id!),
                            ),
                    );
                  },
                ),
        ),
        if (widget.scope != _Scope.tomorrow)
          TextButton.icon(
            onPressed: () => setState(() => _showDone = !_showDone),
            icon: Icon(_showDone ? Icons.visibility_off : Icons.visibility),
            label: Text(_showDone ? l10n.tasksHideDone : l10n.tasksShowDone),
          ),
      ],
    );
  }
}
