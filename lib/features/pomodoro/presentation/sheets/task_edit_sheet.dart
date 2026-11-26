import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../constants/subject_palette.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../widgets/confirm_delete_dialog.dart';

/// Full editor for a task: estimate, priority, due date, subject and delete.
class TaskEditSheet extends ConsumerStatefulWidget {
  const TaskEditSheet({super.key, required this.task});

  final Task task;

  @override
  ConsumerState<TaskEditSheet> createState() => _TaskEditSheetState();
}

class _TaskEditSheetState extends ConsumerState<TaskEditSheet> {
  late Task _task = widget.task;
  late final TextEditingController _title = TextEditingController(
    text: widget.task.title,
  );
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final id = _task.id;
    if (id == null || _saving) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(plannerActionsProvider)
          .updateTask(_task.copyWith(title: _title.text.trim()));
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
      }
    }
  }

  Future<void> _delete() async {
    final id = _task.id;
    if (id == null || _saving) return;
    if (!await confirmDelete(context, name: _task.title)) return;
    ref.read(activeTaskIdProvider.notifier).select(null);
    setState(() => _saving = true);
    try {
      await ref.read(plannerActionsProvider).removeTask(id);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subjectsAsync = ref.watch(subjectsProvider);
    final subjects = subjectsAsync is AsyncData<List<Subject>>
        ? subjectsAsync.value
        : const <Subject>[];
    final estimateTooltip = l10n.taskEstimatedPomodoros;

    return SingleChildScrollView(
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
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: l10n.taskTitleLabel),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.taskEstimatedPomodoros,
                  style: context.textStyles.bodyMedium,
                ),
              ),
              IconButton(
                tooltip: estimateTooltip,
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _task.estimatedPomodoros > 0
                    ? () => setState(
                        () => _task = _task.copyWith(
                          estimatedPomodoros: _task.estimatedPomodoros - 1,
                        ),
                      )
                    : null,
              ),
              Semantics(
                label: estimateTooltip,
                child: Text(
                  _task.estimatedPomodoros == 0
                      ? l10n.taskEstimateNotSet
                      : '${_task.estimatedPomodoros}',
                  style: context.textStyles.titleMedium,
                ),
              ),
              IconButton(
                tooltip: estimateTooltip,
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(
                  () => _task = _task.copyWith(
                    estimatedPomodoros: _task.estimatedPomodoros + 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<TaskPriority>(
            segments: [
              ButtonSegment(
                value: TaskPriority.low,
                label: Text(l10n.taskPriorityLow),
                tooltip: l10n.taskPriorityLow,
              ),
              ButtonSegment(
                value: TaskPriority.medium,
                label: Text(l10n.taskPriorityMedium),
                tooltip: l10n.taskPriorityMedium,
              ),
              ButtonSegment(
                value: TaskPriority.high,
                label: Text(l10n.taskPriorityHigh),
                tooltip: l10n.taskPriorityHigh,
              ),
            ],
            selected: {_task.priority},
            onSelectionChanged: (selection) {
              setState(() => _task = _task.copyWith(priority: selection.first));
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event),
            title: Text(
              _task.dueDate == null
                  ? l10n.taskNoDueDate
                  : '${_task.dueDate!.year}/${_task.dueDate!.month}/${_task.dueDate!.day}',
            ),
            trailing: _task.dueDate == null
                ? null
                : IconButton(
                    tooltip: l10n.actionClear,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(
                      () => _task = _task.copyWith(clearDueDate: true),
                    ),
                  ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _task.dueDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => _task = _task.copyWith(dueDate: picked));
              }
            },
          ),
          if (subjects.isNotEmpty)
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final subject in subjects)
                  _SubjectChoice(
                    subject: subject,
                    selected: _task.subjectId == subject.id,
                    onSelected: (selected) => setState(
                      () => _task = selected
                          ? _task.copyWith(subjectId: subject.id)
                          : _task.copyWith(clearSubject: true),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colors.error,
                  side: BorderSide(color: context.colors.error),
                ),
                onPressed: _saving ? null : () => unawaited(_delete()),
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.actionDelete),
              ),
              const Spacer(),
              AppButton(
                label: _saving ? l10n.statusSaving : l10n.actionSave,
                onPressed: _saving ? null : () => unawaited(_save()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Subject chip with a checkmark for selection, so the choice is not carried
/// by a tint alone. Uses the accessible primary container pair for selected
/// ink instead of an alpha-blended subject colour.
class _SubjectChoice extends StatelessWidget {
  const _SubjectChoice({
    required this.subject,
    required this.selected,
    required this.onSelected,
  });

  final Subject subject;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: selected
          ? Icon(
              Icons.check,
              size: 16,
              color: context.colors.onPrimaryContainer,
            )
          : Icon(
              Icons.circle,
              size: 12,
              color: SubjectPalette.fromHex(subject.colorHex),
            ),
      label: Text(subject.name),
      selected: selected,
      showCheckmark: false,
      onSelected: onSelected,
    );
  }
}
