import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../constants/subject_palette.dart';

/// A planner task row. All mutations are forwarded as callbacks so the tile
/// stays independent of Riverpod and can be reused by other surfaces.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.subjects,
    required this.onToggleDone,
    required this.onDelete,
    required this.onEdit,
    this.onStartFocus,
  });

  final Task task;
  final List<Subject> subjects;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback? onStartFocus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subject = _subjectFor(task.subjectId);
    final subtitle = <String>[
      if (subject != null) subject.name,
      l10n.taskPomodorosCount(task.estimatedPomodoros),
      if (task.dueDate != null)
        '${task.dueDate!.year}/${task.dueDate!.month}/${task.dueDate!.day}',
    ].join(' • ');

    return Dismissible(
      key: ValueKey<String>(task.id?.toString() ?? task.title),
      background: _DismissBackground(
        color: context.colors.tertiaryContainer,
        icon: Icons.check,
        alignment: AlignmentDirectional.centerStart,
      ),
      secondaryBackground: _DismissBackground(
        color: context.colors.errorContainer,
        icon: Icons.delete_outline,
        alignment: AlignmentDirectional.centerEnd,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onToggleDone();
          return false;
        }
        return true;
      },
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: Checkbox(value: task.done, onChanged: (_) => onToggleDone()),
        title: AppText(
          task.title,
          variant: AppTextVariant.body,
          color: task.done ? context.colors.onSurfaceVariant : null,
        ),
        subtitle: AppText(subtitle, variant: AppTextVariant.caption),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                icon: const Icon(Icons.play_circle_outline),
                onPressed: onStartFocus,
              ),
          ],
        ),
        onTap: onEdit,
      ),
    );
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

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({
    required this.color,
    required this.icon,
    required this.alignment,
  });

  final Color color;
  final IconData icon;
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: context.colors.onSurfaceVariant),
    );
  }
}

/// Exposed so other planner widgets can render subject avatars consistently.
Color subjectColor(Subject subject) => SubjectPalette.fromHex(subject.colorHex);
