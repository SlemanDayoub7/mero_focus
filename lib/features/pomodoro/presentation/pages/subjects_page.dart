import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/subject.dart';
import '../constants/subject_palette.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../controllers/focus_totals.dart';
import '../formatting/duration_labels.dart';
import '../sheets/subject_editor_sheet.dart';
import '../sheets/subject_tasks_sheet.dart';
import '../widgets/confirm_delete_dialog.dart';

/// Manage fixed tasks: tap to open subtasks and totals, the three-dot menu
/// edits or deletes (with confirmation).
enum _SubjectMenu { edit, subtasks, delete }

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  void _openEditor(BuildContext context, {Subject? subject}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SubjectEditorSheet(subject: subject),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final subjectsAsync = ref.watch(subjectsProvider);

    return AppScaffold(
      appBar: AppAppBar(title: l10n.subjects),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.actionAdd,
        onPressed: () => _openEditor(context),
        child: const Icon(Icons.add),
      ),
      body: subjectsAsync is! AsyncData<List<Subject>>
          ? const Center(child: CircularProgressIndicator())
          : subjectsAsync.value.isEmpty
          ? Center(child: AppText(l10n.subjectsEmpty))
          : ListView.builder(
              itemCount: subjectsAsync.value.length,
              itemBuilder: (context, index) {
                final subject = subjectsAsync.value[index];
                final total =
                    ref.watch(subjectTotalsProvider)[subject.id] ??
                    const FocusTotal();
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 10,
                      backgroundColor: SubjectPalette.fromHex(subject.colorHex),
                    ),
                    title: AppText(subject.name),
                    subtitle: AppText(
                      '${total.time.labelOf(context)} • ${l10n.subjectSessionsDone(total.sessions)}',
                      variant: AppTextVariant.caption,
                    ),
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SubjectTasksSheet(subject: subject),
                    ),
                    trailing: PopupMenuButton<_SubjectMenu>(
                      tooltip: l10n.actionMore,
                      onSelected: (value) async {
                        switch (value) {
                          case _SubjectMenu.edit:
                            _openEditor(context, subject: subject);
                          case _SubjectMenu.subtasks:
                            await showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => SubjectTasksSheet(subject: subject),
                            );
                          case _SubjectMenu.delete:
                            final id = subject.id;
                            if (id == null) return;
                            if (await confirmDelete(
                              context,
                              name: subject.name,
                            )) {
                              await ref
                                  .read(plannerActionsProvider)
                                  .removeSubject(id);
                            }
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: _SubjectMenu.edit,
                          child: Text(l10n.subjectsEdit),
                        ),
                        PopupMenuItem(
                          value: _SubjectMenu.subtasks,
                          child: Text(l10n.subtasksManage),
                        ),
                        PopupMenuItem(
                          value: _SubjectMenu.delete,
                          child: Text(l10n.actionDelete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
