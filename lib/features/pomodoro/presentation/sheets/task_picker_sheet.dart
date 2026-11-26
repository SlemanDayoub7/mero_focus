import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/task.dart';
import '../../domain/stats/pomodoro_stats.dart';
import '../controllers/planner_providers.dart';
import 'add_task_field.dart';

/// Bottom sheet used by the timer to choose (or quickly add) today's task.
class TaskPickerSheet extends ConsumerWidget {
  const TaskPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tomorrow = startOfDay(DateTime.now()).add(const Duration(days: 1));
    final tasksAsync = ref.watch(tasksProvider);

    void select(int id) {
      ref.read(activeTaskIdProvider.notifier).select(id);
      Navigator.of(context).pop(id);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.taskPick, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          AddTaskField(due: startOfDay(DateTime.now()), onAdded: select),
          const SizedBox(height: AppSpacing.sm),
          if (tasksAsync is! AsyncData<List<Task>>)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.statusLoading,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Semantics(
                  label: l10n.statusLoading,
                  child: const LinearProgressIndicator(),
                ),
              ],
            ),
          if (tasksAsync is AsyncData<List<Task>>)
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final task in tasksAsync.value.where(
                    (task) =>
                        !task.done && task.effectiveDue.isBefore(tomorrow),
                  ))
                    ListTile(
                      title: Text(task.title),
                      onTap: () => select(task.id!),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
