import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/entities/task.dart';
import '../controllers/planner_actions.dart';

/// Quick-add row for a plain task. Subjects live only in the strip at the
/// top of the tasks screen, so there are no subject chips here.
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
          ),
        );
    _controller.clear();
    widget.onAdded?.call(id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
