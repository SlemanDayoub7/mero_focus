import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
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

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _save() {
    final id = _task.id;
    if (id == null) return;
    unawaited(
      ref
          .read(plannerActionsProvider)
          .updateTask(_task.copyWith(title: _title.text.trim()))
          .then((_) {
        if (mounted) Navigator.of(context).pop();
      }),
    );
  }

  Future<void> _delete() async {
    final id = _task.id;
    if (id == null) return;
    if (!await confirmDelete(context, name: _task.title)) return;
    ref.read(activeTaskIdProvider.notifier).select(null);
    unawaited(
      ref
          .read(plannerActionsProvider)
          .removeTask(id)
          .then((_) {
        if (mounted) Navigator.of(context).pop();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subjectsAsync = ref.watch(subjectsProvider);
    final subjects = subjectsAsync is AsyncData<List<Subject>>
        ? subjectsAsync.value
        : const <Subject>[];

    return SingleChildScrollView(
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
          TextField(
            controller: _title,
            decoration: InputDecoration(
              labelText: l10n.taskTitleLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(l10n.taskEstimatedPomodoros)),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _task.estimatedPomodoros > 0
                    ? () => setState(
                          () => _task = _task.copyWith(
                            estimatedPomodoros: _task.estimatedPomodoros - 1,
                          ),
                        )
                    : null,
              ),
              Text(
                _task.estimatedPomodoros == 0
                    ? l10n.taskEstimateNotSet
                    : '${_task.estimatedPomodoros}',
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(
                  () => _task = _task.copyWith(
                    estimatedPomodoros: _task.estimatedPomodoros + 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SegmentedButton<TaskPriority>(
            segments: [
              ButtonSegment(
                value: TaskPriority.low,
                label: Text(l10n.taskPriorityLow),
              ),
              ButtonSegment(
                value: TaskPriority.medium,
                label: Text(l10n.taskPriorityMedium),
              ),
              ButtonSegment(
                value: TaskPriority.high,
                label: Text(l10n.taskPriorityHigh),
              ),
            ],
            selected: {_task.priority},
            onSelectionChanged: (selection) {
              setState(() => _task = _task.copyWith(priority: selection.first));
            },
          ),
          const SizedBox(height: 8),
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
              spacing: 6,
              children: [
                for (final subject in subjects)
                  ChoiceChip(
                    label: Text(subject.name),
                    selected: _task.subjectId == subject.id,
                    selectedColor: SubjectPalette.fromHex(subject.colorHex)
                        .withValues(alpha: 0.35),
                    onSelected: (selected) => setState(
                      () => _task = selected
                          ? _task.copyWith(subjectId: subject.id)
                          : _task.copyWith(clearSubject: true),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => unawaited(_delete()),
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.actionDelete),
              ),
              const Spacer(),
              AppButton(label: l10n.actionSave, onPressed: _save),
            ],
          ),
        ],
      ),
    );
  }
}
