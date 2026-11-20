import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/task.dart';
import '../constants/subject_palette.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';

/// Quick-add row with optional subject chips, used on task scopes and sheets.
class AddTaskField extends ConsumerStatefulWidget {
  const AddTaskField({
    super.key,
    required this.due,
    this.onAdded,
  });

  final DateTime due;
  final void Function(int taskId)? onAdded;

  @override
  ConsumerState<AddTaskField> createState() => _AddTaskFieldState();
}

class _AddTaskFieldState extends ConsumerState<AddTaskField> {
  final _controller = TextEditingController();
  int? _subjectId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final id = await ref.read(plannerActionsProvider).addTask(
          Task(
            title: title,
            createdAt: DateTime.now(),
            dueDate: widget.due,
            subjectId: _subjectId,
          ),
        );
    _controller.clear();
    widget.onAdded?.call(id);
  }

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectsProvider);
    final subjects = subjectsAsync is AsyncData<List<Subject>>
        ? subjectsAsync.value
        : const <Subject>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => unawaited(_add()),
                decoration: InputDecoration(
                  hintText: context.l10n.tasksAddHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: context.l10n.actionAdd,
              icon: const Icon(Icons.add),
              onPressed: () => unawaited(_add()),
            ),
          ],
        ),
        if (subjects.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 6,
              children: [
                for (final subject in subjects)
                  ChoiceChip(
                    label: Text(subject.name),
                    selected: _subjectId == subject.id,
                    selectedColor: SubjectPalette.fromHex(subject.colorHex)
                        .withValues(alpha: 0.35),
                    onSelected: (selected) {
                      setState(
                        () => _subjectId = selected ? subject.id : null,
                      );
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
