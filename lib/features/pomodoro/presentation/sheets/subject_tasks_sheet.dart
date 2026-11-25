import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/subtask.dart';
import '../constants/subject_palette.dart';
import '../controllers/focus_totals.dart';
import '../controllers/subtasks_provider.dart';
import '../formatting/duration_labels.dart';
import '../pages/focus_launcher.dart';
import '../widgets/confirm_delete_dialog.dart';

enum _SubtaskMenu { rename, delete }

/// A fixed task with its optional subtasks: the all-time total on top, the
/// time of each subtask below, and play buttons that start a focus session on
/// a subtask (or on the fixed task itself).
class SubjectTasksSheet extends ConsumerStatefulWidget {
  const SubjectTasksSheet({super.key, required this.subject});

  final Subject subject;

  @override
  ConsumerState<SubjectTasksSheet> createState() => _SubjectTasksSheetState();
}

class _SubjectTasksSheetState extends ConsumerState<SubjectTasksSheet> {
  final TextEditingController _newName = TextEditingController();

  @override
  void dispose() {
    _newName.dispose();
    super.dispose();
  }

  Future<void> _addSubtask() async {
    final id = widget.subject.id;
    if (id == null) return;
    final name = _newName.text;
    _newName.clear();
    await ref.read(subtasksProvider.notifier).add(id, name);
  }

  /// Starts focus and shows the timer; the sheet is closed on the way.
  Future<void> _start({String? subtaskId}) async {
    await prepareFocusForSubject(ref, widget.subject, subtaskId: subtaskId);
    if (!mounted) return;
    final navigator = Navigator.of(context);
    navigator.pop();
    await pushTimerPage(navigator);
  }

  Future<void> _rename(Subtask subtask) async {
    final controller = TextEditingController(text: subtask.name);
    final l10n = context.l10n;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.subtaskRename),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.subtaskNameHint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) {
      await ref.read(subtasksProvider.notifier).rename(subtask.id, result);
    }
  }

  Future<void> _delete(Subtask subtask) async {
    final confirmed = await confirmDelete(context, name: subtask.name);
    if (confirmed) {
      await ref.read(subtasksProvider.notifier).remove(subtask.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final subject = widget.subject;
    final subjectId = subject.id;
    final subtasks = <Subtask>[
      for (final item in ref.watch(subtasksProvider))
        if (item.subjectId == subjectId) item,
    ];
    final subjectTotals = ref.watch(subjectTotalsProvider);
    final subtaskTotals = ref.watch(subtaskTotalsProvider);
    final total = (subjectId == null ? null : subjectTotals[subjectId]) ??
        const FocusTotal();

    var subtaskTime = Duration.zero;
    for (final item in subtasks) {
      subtaskTime += (subtaskTotals[item.id] ?? const FocusTotal()).time;
    }
    final generalTime = total.time > subtaskTime
        ? total.time - subtaskTime
        : Duration.zero;

    final color = SubjectPalette.fromHex(subject.colorHex);

    return SafeArea(
      child: SingleChildScrollView(
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
            Row(
              children: [
                CircleAvatar(radius: 8, backgroundColor: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(subject.name, style: theme.textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: color.withValues(alpha: 0.18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.subtaskTotalAllTime,
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            total.time.label(l10n),
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      l10n.subjectSessionsDone(total.sessions),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.layers_outlined),
              title: Text(l10n.subtaskGeneral),
              subtitle: Text(generalTime.label(l10n)),
              trailing: IconButton.filledTonal(
                tooltip: l10n.taskStartFocus,
                icon: const Icon(Icons.play_arrow),
                onPressed: () => unawaited(_start()),
              ),
              onTap: () => unawaited(_start()),
            ),
            for (final subtask in subtasks)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.subdirectory_arrow_right),
                title: Text(subtask.name),
                subtitle: Text(
                  '${(subtaskTotals[subtask.id] ?? const FocusTotal()).time.label(l10n)}'
                  ' • ${l10n.subjectSessionsDone((subtaskTotals[subtask.id] ?? const FocusTotal()).sessions)}',
                ),
                onTap: () => unawaited(_start(subtaskId: subtask.id)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      tooltip: l10n.taskStartFocus,
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () => unawaited(_start(subtaskId: subtask.id)),
                    ),
                    PopupMenuButton<_SubtaskMenu>(
                      tooltip: l10n.actionMore,
                      onSelected: (value) {
                        switch (value) {
                          case _SubtaskMenu.rename:
                            unawaited(_rename(subtask));
                          case _SubtaskMenu.delete:
                            unawaited(_delete(subtask));
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: _SubtaskMenu.rename,
                          child: Text(l10n.subtaskRename),
                        ),
                        PopupMenuItem(
                          value: _SubtaskMenu.delete,
                          child: Text(l10n.actionDelete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newName,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => unawaited(_addSubtask()),
                    decoration: InputDecoration(
                      hintText: l10n.subtaskAddHint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: l10n.actionAdd,
                  icon: const Icon(Icons.add),
                  onPressed: () => unawaited(_addSubtask()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
