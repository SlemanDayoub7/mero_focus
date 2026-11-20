import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/task.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';

/// Completed tasks, newest first, with an explicit reopen action.
class DoneTasksPage extends ConsumerWidget {
  const DoneTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tasksAsync = ref.watch(tasksProvider);

    if (tasksAsync is! AsyncData<List<Task>>) {
      return const AppScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final done = tasksAsync.value.where((task) => task.done).toList()
      ..sort(
        (a, b) => (b.completedAt ?? b.createdAt).compareTo(
          a.completedAt ?? a.createdAt,
        ),
      );

    return AppScaffold(
      appBar: AppAppBar(title: l10n.tasksDone),
      body: done.isEmpty
          ? Center(child: AppText(l10n.tasksEmpty))
          : ListView.builder(
              itemCount: done.length,
              itemBuilder: (context, index) {
                final task = done[index];
                return ListTile(
                  title: AppText(task.title),
                  trailing: IconButton(
                    tooltip: l10n.actionReopen,
                    icon: const Icon(Icons.undo),
                    onPressed: () => ref
                        .read(plannerActionsProvider)
                        .setTaskDone(task, done: false),
                  ),
                );
              },
            ),
    );
  }
}
