import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../constants/subject_palette.dart';
import '../controllers/focus_totals.dart';
import '../formatting/duration_labels.dart';
import 'confirm_delete_dialog.dart';

enum _TaskMenu { edit, toggleDone, delete }

/// A planner task card. All mutations are forwarded as callbacks so the tile
/// stays independent of Riverpod. Actions live in a three-dot menu (edit,
/// mark done / reopen, delete with confirmation); there is no swipe.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.subjects,
    required this.onToggleDone,
    required this.onDelete,
    required this.onEdit,
    this.onStartFocus,
    this.total = const FocusTotal(),
  });

  final Task task;
  final List<Subject> subjects;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback? onStartFocus;

  /// Time spent and completed sessions on this task.
  final FocusTotal total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final subject = _subjectFor(task.subjectId);
    final accent = subject == null
        ? theme.colorScheme.outlineVariant
        : SubjectPalette.fromHex(subject.colorHex);

    final details = <String>[
      if (subject != null) subject.name,
      // Estimated sessions are shown only when the user set them.
      if (task.estimatedPomodoros > 0)
        l10n.taskEstimatedSessions(task.estimatedPomodoros),
      if (task.dueDate != null)
        '${task.dueDate!.year}/${task.dueDate!.month}/${task.dueDate!.day}',
    ].join(' • ');
    final spent = l10n.taskSpentSummary(total.time.label(l10n), total.sessions);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: AppColors.glassSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Color strip = the fixed task this belongs to.
              Container(width: 5, color: accent),
              Checkbox(
                value: task.done,
                onChanged: (_) => onToggleDone(),
                shape: const CircleBorder(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        task.title,
                        variant: AppTextVariant.body,
                        color: task.done
                            ? context.colors.onSurfaceVariant
                            : null,
                      ),
                      if (details.isNotEmpty)
                        AppText(details, variant: AppTextVariant.caption),
                      AppText(spent, variant: AppTextVariant.caption),
                    ],
                  ),
                ),
              ),
              Tooltip(
                message: _priorityLabel(task.priority, l10n),
                child: Icon(
                  Icons.flag,
                  size: 18,
                  color: _priorityColor(task.priority, context),
                ),
              ),
              if (onStartFocus != null)
                IconButton(
                  tooltip: l10n.taskStartFocus,
                  icon: const Icon(Icons.play_arrow),
                  onPressed: onStartFocus,
                ),
              PopupMenuButton<_TaskMenu>(
                tooltip: l10n.actionMore,
                onSelected: (value) {
                  switch (value) {
                    case _TaskMenu.edit:
                      onEdit();
                    case _TaskMenu.toggleDone:
                      onToggleDone();
                    case _TaskMenu.delete:
                      unawaited(_confirmAndDelete(context));
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _TaskMenu.edit,
                    child: Text(l10n.actionEdit),
                  ),
                  PopupMenuItem(
                    value: _TaskMenu.toggleDone,
                    child: Text(
                      task.done ? l10n.actionReopen : l10n.actionMarkDone,
                    ),
                  ),
                  PopupMenuItem(
                    value: _TaskMenu.delete,
                    child: Text(l10n.actionDelete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    if (await confirmDelete(context, name: task.title)) onDelete();
  }

  Subject? _subjectFor(int? id) {
    for (final candidate in subjects) {
      if (candidate.id == id) return candidate;
    }
    return null;
  }

  Color _priorityColor(TaskPriority priority, BuildContext context) {
    return switch (priority) {
      TaskPriority.high => context.colors.error,
      TaskPriority.medium => context.colors.tertiary,
      TaskPriority.low => context.colors.outline,
    };
  }

  String _priorityLabel(TaskPriority priority, AppLocalizations l10n) {
    return switch (priority) {
      TaskPriority.high => l10n.taskPriorityHigh,
      TaskPriority.medium => l10n.taskPriorityMedium,
      TaskPriority.low => l10n.taskPriorityLow,
    };
  }
}

/// Exposed so other planner widgets can render subject avatars consistently.
Color subjectColor(Subject subject) => SubjectPalette.fromHex(subject.colorHex);
