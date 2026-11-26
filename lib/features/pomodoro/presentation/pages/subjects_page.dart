import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/subject.dart';
import '../constants/subject_palette.dart';
import '../controllers/focus_totals.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../formatting/duration_labels.dart';
import '../sheets/subject_editor_sheet.dart';
import '../sheets/subject_tasks_sheet.dart';
import '../widgets/confirm_delete_dialog.dart';

/// Manage fixed tasks: tap to open subtasks and totals, the visible three-dot
/// menu edits or deletes (with confirmation).
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
      body: _SubjectsBody(subjectsAsync: subjectsAsync),
    );
  }
}

class _SubjectsBody extends ConsumerWidget {
  const _SubjectsBody({required this.subjectsAsync});

  final AsyncValue<List<Subject>> subjectsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final totals = ref.watch(subjectTotalsProvider);

    if (subjectsAsync.hasError) {
      return _StatusPanel(
        icon: Icons.error_outline,
        iconColor: context.colors.error,
        title: l10n.errorLoadFailed,
        body: l10n.errorGeneric,
        actionLabel: l10n.actionRetry,
        onAction: () => ref.invalidate(subjectsProvider),
      );
    }
    if (!subjectsAsync.hasValue) {
      return _StatusPanel(loading: true, title: l10n.statusLoading);
    }

    final subjects = subjectsAsync.value!;
    if (subjects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_tree_outlined,
                size: 48,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.subjectsEmpty,
                style: context.textStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        final total = totals[subject.id] ?? const FocusTotal();
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          color: context.colors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 8,
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
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SubjectEditorSheet(subject: subject),
                    );
                  case _SubjectMenu.subtasks:
                    await showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SubjectTasksSheet(subject: subject),
                    );
                  case _SubjectMenu.delete:
                    final id = subject.id;
                    if (id == null) return;
                    if (await confirmDelete(context, name: subject.name)) {
                      await ref.read(plannerActionsProvider).removeSubject(id);
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
    );
  }
}

/// Labelled loading / error surface shared by the planner screens. A spinner
/// is never shown on its own, and every failure offers a visible retry.
class _StatusPanel extends StatelessWidget {
  const _StatusPanel({
    this.loading = false,
    this.icon,
    this.iconColor,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final bool loading;
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (loading)
              Semantics(label: title, child: const CircularProgressIndicator())
            else if (icon != null)
              Icon(icon, size: 40, color: iconColor ?? context.colors.primary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: context.textStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                body!,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
