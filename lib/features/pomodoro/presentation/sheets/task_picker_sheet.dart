import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
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
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.taskPick, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AddTaskField(
            due: startOfDay(DateTime.now()),
            onAdded: select,
          ),
          const SizedBox(height: 8),
          if (tasksAsync is! AsyncData<List<Task>>)
            const LinearProgressIndicator(),
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
