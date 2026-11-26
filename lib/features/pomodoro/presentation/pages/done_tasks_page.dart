import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
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

    return AppScaffold(
      appBar: AppAppBar(title: l10n.tasksDone),
      body: _DoneTasksBody(tasksAsync: tasksAsync),
    );
  }
}

class _DoneTasksBody extends ConsumerWidget {
  const _DoneTasksBody({required this.tasksAsync});

  final AsyncValue<List<Task>> tasksAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    if (tasksAsync.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40, color: context.colors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.errorLoadFailed,
                style: context.textStyles.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.errorGeneric,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => ref.invalidate(tasksProvider),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.actionRetry),
              ),
            ],
          ),
        ),
      );
    }
    if (!tasksAsync.hasValue) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: l10n.statusLoading,
              child: const CircularProgressIndicator(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.statusLoading, style: context.textStyles.bodyMedium),
          ],
        ),
      );
    }

    final done = tasksAsync.value!.where((task) => task.done).toList()
      ..sort(
        (a, b) => (b.completedAt ?? b.createdAt).compareTo(
          a.completedAt ?? a.createdAt,
        ),
      );

    if (done.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.tasksEmpty,
                style: context.textStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: done.length,
      itemBuilder: (context, index) {
        final task = done[index];
        return ListTile(
          title: AppText(task.title),
          trailing: IconButton(
            tooltip: l10n.actionReopen,
            icon: const Icon(Icons.undo),
            onPressed: () =>
                ref.read(plannerActionsProvider).setTaskDone(task, done: false),
          ),
        );
      },
    );
  }
}
