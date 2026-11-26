import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/study_goal.dart';
import '../controllers/goals_provider.dart';
import '../widgets/confirm_delete_dialog.dart';

/// Hours per day offered in the quick plan.
const List<int> kGoalPlanHours = <int>[4, 5, 6, 7];

String _dateLabel(DateTime date) => '${date.year}/${date.month}/${date.day}';

/// Sheet to add or edit a goal: a free name and an optional end date.
class GoalEditSheet extends ConsumerStatefulWidget {
  const GoalEditSheet({super.key, this.initial});

  final StudyGoal? initial;

  @override
  ConsumerState<GoalEditSheet> createState() => _GoalEditSheetState();
}

class _GoalEditSheetState extends ConsumerState<GoalEditSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.initial?.name ?? '',
  );
  late DateTime? _date = widget.initial?.date;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 30)),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty || _saving) return;
    final notifier = ref.read(goalsProvider.notifier);
    final initial = widget.initial;

    setState(() => _saving = true);
    try {
      await notifier.save(
        StudyGoal(id: initial?.id ?? notifier.newId(), name: name, date: _date),
      );
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

  Future<void> _remove() async {
    final initial = widget.initial;
    if (initial != null) {
      if (!await confirmDelete(context, name: initial.name)) return;
      setState(() => _saving = true);
      try {
        await ref.read(goalsProvider.notifier).remove(initial.id);
      } catch (_) {
        if (mounted) {
          setState(() => _saving = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
          return;
        }
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canSave = _name.text.trim().isNotEmpty;

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
            controller: _name,
            autofocus: widget.initial == null,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l10n.goalNameLabel,
              hintText: l10n.goalNameHint,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event),
            title: Text(l10n.goalDateLabel),
            subtitle: Text(
              _date == null ? l10n.goalNoDate : _dateLabel(_date!),
            ),
            trailing: _date == null
                ? null
                : IconButton(
                    tooltip: l10n.actionClear,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _date = null),
                  ),
            onTap: () => unawaited(_pickDate()),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (widget.initial != null)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.error,
                    side: BorderSide(color: context.colors.error),
                  ),
                  onPressed: _saving ? null : () => unawaited(_remove()),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.examRemove),
                ),
              const Spacer(),
              FilledButton(
                onPressed: canSave && !_saving
                    ? () => unawaited(_save())
                    : null,
                child: Text(_saving ? l10n.statusSaving : l10n.actionSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quick plan for a dated goal: what the student reaches by the end date at
/// 4/5/6/7 hours a day.
class GoalPlanSheet extends StatelessWidget {
  const GoalPlanSheet({super.key, required this.goal});

  final StudyGoal goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final days = goal.daysLeft(now) ?? 0;
    final date = goal.date;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(goal.name, style: context.textStyles.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${l10n.examDaysLeft(days < 0 ? 0 : days)}'
              '${date == null ? '' : ' • ${_dateLabel(date)}'}',
              style: context.textStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            if (days <= 0)
              Text(l10n.examPlanNoDays, style: context.textStyles.bodyMedium)
            else ...[
              Text(l10n.examPlanIntro, style: context.textStyles.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final hours in kGoalPlanHours)
                Card(
                  elevation: 0,
                  color: context.colors.surfaceContainerHigh,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.colors.primaryContainer,
                      child: Text(
                        '$hours',
                        style: AppTypography.bodyStrong.copyWith(
                          color: context.colors.onPrimaryContainer,
                        ),
                      ),
                    ),
                    title: Text(l10n.examPlanPerDay(hours)),
                    subtitle: Text(
                      l10n.examPlanTotal(goal.totalHours(hours, now)),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.examPlanMotivation,
                style: context.textStyles.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
