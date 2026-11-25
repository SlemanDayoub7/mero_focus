import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/entities/subject.dart';
import '../constants/subject_palette.dart';
import '../controllers/focus_totals.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../pages/focus_launcher.dart';
import '../controllers/subtasks_provider.dart';
import '../formatting/duration_labels.dart';
import '../sheets/subject_editor_sheet.dart';
import '../sheets/subject_tasks_sheet.dart';
import 'confirm_delete_dialog.dart';

/// Always-visible row of subjects at the top of the tasks screen.
/// Tap = add today's task for the subject (once per day) and start focus, long-press = edit / delete,
/// trailing "+" = add a subject.
class SubjectsStrip extends ConsumerWidget {
  const SubjectsStrip({super.key});

  void _openEditor(BuildContext context, {Subject? subject}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SubjectEditorSheet(subject: subject),
    );
  }

  void _openSubtasks(BuildContext context, Subject subject) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SubjectTasksSheet(subject: subject),
    );
  }

  /// A fixed task with subtasks opens its list; without subtasks a tap starts
  /// focus straight away.
  void _onTap(BuildContext context, WidgetRef ref, Subject subject) {
    final hasSubtasks = ref
        .read(subtasksProvider)
        .any((item) => item.subjectId == subject.id);
    if (hasSubtasks) {
      _openSubtasks(context, subject);
    } else {
      unawaited(startFocusForSubject(context, ref, subject));
    }
  }

  void _showMenu(BuildContext context, WidgetRef ref, Subject subject) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.subjectsEdit),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openEditor(context, subject: subject);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: Text(l10n.subtasksManage),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openSubtasks(context, subject);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.actionDelete),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final id = subject.id;
                if (id == null) return;
                if (await confirmDelete(context, name: subject.name)) {
                  unawaited(ref.read(plannerActionsProvider).removeSubject(id));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final subjectsAsync = ref.watch(subjectsProvider);
    final subjects = subjectsAsync is AsyncData<List<Subject>>
        ? subjectsAsync.value
        : const <Subject>[];
    final totals = ref.watch(subjectTotalsProvider);

    return SizedBox(
      height: 68,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          for (final subject in subjects)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: GestureDetector(
                onLongPress: () => _showMenu(context, ref, subject),
                child: ActionChip(
                  avatar: CircleAvatar(
                    radius: 6,
                    backgroundColor: SubjectPalette.fromHex(subject.colorHex),
                  ),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(subject.name),
                      Text(
                        '${(totals[subject.id]?.time ?? Duration.zero).label(l10n)}'
                        ' • ${l10n.subjectSessionsDone(totals[subject.id]?.sessions ?? 0)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  backgroundColor: SubjectPalette.fromHex(
                    subject.colorHex,
                  ).withValues(alpha: 0.2),
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  onPressed: () => _onTap(context, ref, subject),
                ),
              ),
            ),
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: Text(l10n.actionAdd),
            shape: const StadiumBorder(),
            onPressed: () => _openEditor(context),
          ),
        ],
      ),
    );
  }
}
