import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/services/reminder_notification_service.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/subject.dart';
import '../controllers/planner_providers.dart';
import '../controllers/reminders_provider.dart';
import '../sheets/reminder_edit_sheet.dart';
import '../widgets/confirm_delete_dialog.dart';

enum _ReminderMenu { edit, delete }

/// Study reminders: the user's own, plus ready-made suggestions and a smart
/// reminder that only fires on days nothing has been studied. Everything is
/// stored and scheduled locally, so it works offline.
class RemindersPage extends ConsumerStatefulWidget {
  const RemindersPage({super.key});

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage> {
  bool _requesting = false;
  bool _permissionDenied = false;
  bool _savingSmart = false;

  void _edit(Reminder reminder) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReminderEditSheet(initial: reminder),
    );
  }

  Future<void> _requestPermission() async {
    if (_requesting) return;
    setState(() {
      _requesting = true;
      _permissionDenied = false;
    });
    final granted = await ref.read(reminderServiceProvider).requestPermission();
    ref.invalidate(notificationsEnabledProvider);
    if (!mounted) return;
    setState(() {
      _requesting = false;
      if (!granted) _permissionDenied = true;
    });
  }

  Future<void> _updateSmart(SmartReminder value) async {
    if (_savingSmart) return;
    setState(() => _savingSmart = true);
    try {
      await ref.read(smartReminderProvider.notifier).update(value);
      if (value.enabled) {
        final service = ref.read(reminderServiceProvider);
        if (!await service.notificationsEnabled()) {
          await _requestPermission();
        }
      }
    } finally {
      if (mounted) setState(() => _savingSmart = false);
    }
  }

  String _summary(BuildContext context, Reminder reminder) {
    final l10n = context.l10n;
    return switch (reminder.repeat) {
      ReminderRepeat.daily => l10n.reminderEveryDay,
      ReminderRepeat.days => [
        for (final day in kWeekOrder)
          if (reminder.weekdays.contains(day)) weekdayName(l10n, day),
      ].join(' • '),
      ReminderRepeat.once =>
        reminder.date == null
            ? l10n.reminderRepeatOnce
            : l10n.reminderOnceOn(
                '${reminder.date!.year}/${reminder.date!.month}/${reminder.date!.day}',
              ),
    };
  }

  Widget _permissionNotice(AsyncValue<bool> permission) {
    final l10n = context.l10n;
    return permission.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: LinearProgressIndicator(minHeight: 3),
      ),
      error: (_, _) => _NoticeRow(
        title: l10n.errorLoadFailed,
        body: l10n.errorGeneric,
        actionLabel: l10n.actionRetry,
        onAction: () => ref.invalidate(notificationsEnabledProvider),
      ),
      data: (enabled) {
        if (enabled && !_permissionDenied) return const SizedBox.shrink();
        return _NoticeRow(
          title: l10n.reminderNotificationsOff,
          body: l10n.reminderBody,
          errorBody: _permissionDenied ? l10n.errorGeneric : null,
          actionLabel: _permissionDenied
              ? l10n.actionRetry
              : _requesting
              ? l10n.statusLoading
              : l10n.reminderAllow,
          busy: _requesting,
          onAction: _requestPermission,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final reminders = ref.watch(remindersProvider);
    final smart = ref.watch(smartReminderProvider);
    final permission = ref.watch(notificationsEnabledProvider);
    final subjectsAsync = ref.watch(subjectsProvider);
    final subjects = subjectsAsync is AsyncData<List<Subject>>
        ? subjectsAsync.value
        : const <Subject>[];

    final suggestions = <({String title, int hour, int minute})>[
      (title: l10n.reminderSuggestMorning, hour: 8, minute: 0),
      (title: l10n.reminderSuggestEvening, hour: 20, minute: 0),
      (title: l10n.reminderSuggestPlan, hour: 22, minute: 0),
    ];

    final sorted = <Reminder>[...reminders]
      ..sort(
        (a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute),
      );

    return AppScaffold(
      appBar: AppAppBar(title: l10n.reminders),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_alert_outlined),
        label: Text(l10n.reminderAdd),
        onPressed: () => _edit(
          const Reminder(id: 0, title: '', hour: 18, minute: 0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          96,
        ),
        children: [
          _permissionNotice(permission),

          // --- Smart reminder ------------------------------------------
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.outlineVariant),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: colors.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.reminderSmartSwitch,
                              style: AppTypography.bodyStrong,
                            ),
                            Text(
                              l10n.reminderSmartSubtitle,
                              style: AppTypography.caption.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            if (_savingSmart)
                              Text(
                                l10n.statusSaving,
                                style: AppTypography.caption.copyWith(
                                  color: colors.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Semantics(
                        label: l10n.reminderSmartSwitch,
                        value: smart.enabled
                            ? l10n.statusEnabled
                            : l10n.statusDisabled,
                        child: Switch(
                          value: smart.enabled,
                          onChanged: _savingSmart
                              ? null
                              : (value) =>
                                  unawaited(_updateSmart(smart.copyWith(enabled: value))),
                        ),
                      ),
                    ],
                  ),
                ),
                if (smart.enabled)
                  Semantics(
                    button: true,
                    label:
                        '${l10n.reminderTime}, '
                        '${TimeOfDay(hour: smart.hour, minute: smart.minute).format(context)}',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.access_time, color: colors.primary),
                      title: Text(l10n.reminderTime, style: AppTypography.body),
                      trailing: Text(
                        TimeOfDay(
                          hour: smart.hour,
                          minute: smart.minute,
                        ).format(context),
                        style: AppTypography.label,
                      ),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: smart.hour,
                            minute: smart.minute,
                          ),
                        );
                        if (picked != null) {
                          await _updateSmart(
                            smart.copyWith(
                              hour: picked.hour,
                              minute: picked.minute,
                            ),
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),

          // --- Suggestions ---------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              AppSpacing.lg,
              0,
              AppSpacing.sm,
            ),
            child: Text(
              l10n.reminderSuggestedTitle,
              style: AppTypography.title,
            ),
          ),
          Wrap(
            spacing: AppSpacing.touchTargetGap,
            runSpacing: AppSpacing.touchTargetGap,
            children: [
              for (final suggestion in suggestions)
                Semantics(
                  button: true,
                  label:
                      '${suggestion.title}, '
                      '${TimeOfDay(hour: suggestion.hour, minute: suggestion.minute).format(context)}',
                  child: ActionChip(
                    avatar: const Icon(Icons.add, size: 20),
                    label: Text(
                      '${suggestion.title} • '
                      '${TimeOfDay(hour: suggestion.hour, minute: suggestion.minute).format(context)}',
                      style: AppTypography.caption,
                    ),
                    onPressed: () => _edit(
                      Reminder(
                        id: 0,
                        title: suggestion.title,
                        hour: suggestion.hour,
                        minute: suggestion.minute,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // --- My reminders --------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              AppSpacing.lg,
              0,
              AppSpacing.sm,
            ),
            child: Text(l10n.reminders, style: AppTypography.title),
          ),
          if (sorted.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 32,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.remindersEmpty,
                    style: AppTypography.body,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          for (final reminder in sorted)
            _ReminderCard(
              reminder: reminder,
              summary: _summary(context, reminder),
              subjectName: subjects
                  .where((subject) => subject.id == reminder.subjectId)
                  .map((subject) => subject.name)
                  .firstOrNull,
              l10n: l10n,
              onToggle: (value) => unawaited(
                ref
                    .read(remindersProvider.notifier)
                    .setEnabled(reminder.id, enabled: value),
              ),
              onEdit: () => _edit(reminder),
              onDelete: () async {
                if (await confirmDelete(
                  context,
                  name: reminder.title.isEmpty
                      ? l10n.reminderDefaultTitle
                      : reminder.title,
                )) {
                  await ref.read(remindersProvider.notifier).remove(reminder.id);
                }
              },
            ),
        ],
      ),
    );
  }
}

/// Permission and failure states use the same quiet shape: what happened, why
/// it matters, and one accessible next step.
class _NoticeRow extends StatelessWidget {
  const _NoticeRow({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.errorBody,
    this.busy = false,
  });

  final String title;
  final String body;
  final String? errorBody;
  final String actionLabel;
  final VoidCallback onAction;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final error = errorBody != null;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: error
            ? colors.errorContainer
            : colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            error ? Icons.error_outline : Icons.notifications_none,
            color: error
                ? colors.onErrorContainer
                : colors.onPrimaryContainer,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyStrong.copyWith(
                    color: error
                        ? colors.onErrorContainer
                        : colors.onPrimaryContainer,
                  ),
                ),
                Text(
                  body,
                  style: AppTypography.caption.copyWith(
                    color: error
                        ? colors.onErrorContainer
                        : colors.onPrimaryContainer,
                  ),
                ),
                if (errorBody != null)
                  Text(
                    errorBody!,
                    style: AppTypography.caption.copyWith(
                      color: colors.onErrorContainer,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Semantics(
            button: true,
            label: actionLabel,
            child: OutlinedButton(
              onPressed: busy ? null : onAction,
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.summary,
    required this.subjectName,
    required this.l10n,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Reminder reminder;
  final String summary;
  final String? subjectName;
  final AppLocalizations l10n;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = reminder.title.isEmpty
        ? l10n.reminderDefaultTitle
        : reminder.title;
    final time = TimeOfDay(
      hour: reminder.hour,
      minute: reminder.minute,
    ).format(context);

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  label: '${l10n.actionEdit}: $title, $time',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    onTap: onEdit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Text(time, style: AppTypography.title),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.body,
                                ),
                                Text(
                                  summary,
                                  style: AppTypography.caption.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                                if (subjectName != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.link,
                                        size: 16,
                                        color: colors.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Flexible(
                                        child: Text(
                                          subjectName!,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.caption.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Semantics(
                label: title,
                value: reminder.enabled
                    ? l10n.statusEnabled
                    : l10n.statusDisabled,
                child: Switch(
                  value: reminder.enabled,
                  onChanged: onToggle,
                ),
              ),
              PopupMenuButton<_ReminderMenu>(
                tooltip: l10n.actionMore,
                onSelected: (value) {
                  switch (value) {
                    case _ReminderMenu.edit:
                      onEdit();
                    case _ReminderMenu.delete:
                      unawaited(onDelete());
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _ReminderMenu.edit,
                    height: AppSpacing.minTouchTarget,
                    child: Text(l10n.actionEdit),
                  ),
                  PopupMenuItem(
                    value: _ReminderMenu.delete,
                    height: AppSpacing.minTouchTarget,
                    child: Text(l10n.actionDelete),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.outlineVariant),
      ],
    );
  }
}
