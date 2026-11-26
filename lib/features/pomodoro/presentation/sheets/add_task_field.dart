import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/task.dart';
import '../controllers/planner_actions.dart';

/// Quick-add row for a plain task. Subjects live only in the strip at the
/// top of the tasks screen, so there are no subject chips here.
///
/// This is the single primary action on the planner: the add control is filled
/// while every other control on the screen is tonal, outlined or an icon.
class AddTaskField extends ConsumerStatefulWidget {
  const AddTaskField({super.key, required this.due, this.onAdded});

  final DateTime due;
  final void Function(int taskId)? onAdded;

  @override
  ConsumerState<AddTaskField> createState() => _AddTaskFieldState();
}

class _AddTaskFieldState extends ConsumerState<AddTaskField> {
  final _controller = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty || _adding) return;

    setState(() => _adding = true);
    try {
      final id = await ref
          .read(plannerActionsProvider)
          .addTask(
            Task(title: title, createdAt: DateTime.now(), dueDate: widget.due),
          );
      _controller.clear();
      widget.onAdded?.call(id);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => unawaited(_add()),
            decoration: InputDecoration(
              hintText: l10n.tasksAddHint,
              suffixIcon: _adding
                  ? Semantics(
                      label: l10n.statusSaving,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: SizedBox(
                          width: AppSpacing.md,
                          height: AppSpacing.md,
                          child: CircularProgressIndicator(
                            color: context.colors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Semantics(
          button: true,
          enabled: !_adding,
          label: l10n.actionAdd,
          child: IconButton.filled(
            tooltip: l10n.actionAdd,
            icon: const Icon(Icons.add),
            onPressed: _adding ? null : () => unawaited(_add()),
          ),
        ),
      ],
    );
  }
}
