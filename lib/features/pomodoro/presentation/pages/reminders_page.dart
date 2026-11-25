import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
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
class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  void _edit(BuildContext context, Reminder reminder) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReminderEditSheet(initial: reminder),
    );
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
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
          context,
          const Reminder(id: 0, title: '', hour: 18, minute: 0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        children: [
          if (permission.value == false)
            Card(
              elevation: 0,
              color: theme.colorScheme.errorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.notifications_off_outlined,
                  color: theme.colorScheme.onErrorContainer,
                ),
                title: Text(
                  l10n.reminderNotificationsOff,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
                trailing: FilledButton(
                  onPressed: () async {
                    await ref.read(reminderServiceProvider).requestPermission();
                    ref.invalidate(notificationsEnabledProvider);
                  },
                  child: Text(l10n.reminderAllow),
                ),
              ),
            ),

          // --- Smart reminder ------------------------------------------
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.auto_awesome),
                  title: Text(l10n.reminderSmartSwitch),
                  subtitle: Text(l10n.reminderSmartSubtitle),
                  value: smart.enabled,
                  onChanged: (value) async {
                    await ref
                        .read(smartReminderProvider.notifier)
                        .update(smart.copyWith(enabled: value));
                    if (value) {
                      final service = ref.read(reminderServiceProvider);
                      if (!await service.notificationsEnabled()) {
                        await service.requestPermission();
                        ref.invalidate(notificationsEnabledProvider);
                      }
                    }
                  },
                ),
                if (smart.enabled)
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(l10n.reminderTime),
                    trailing: Text(
                      TimeOfDay(
                        hour: smart.hour,
                        minute: smart.minute,
                      ).format(context),
                      style: theme.textTheme.titleMedium,
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
                        await ref
                            .read(smartReminderProvider.notifier)
                            .update(
                              smart.copyWith(
                                hour: picked.hour,
                                minute: picked.minute,
                              ),
                            );
                      }
                    },
                  ),
              ],
            ),
          ),

          // --- Suggestions ---------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
            child: Text(
              l10n.reminderSuggestedTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final suggestion in suggestions)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(
                    '${suggestion.title} • '
                    '${TimeOfDay(hour: suggestion.hour, minute: suggestion.minute).format(context)}',
                  ),
                  onPressed: () => _edit(
                    context,
                    Reminder(
                      id: 0,
                      title: suggestion.title,
                      hour: suggestion.hour,
                      minute: suggestion.minute,
                    ),
                  ),
                ),
            ],
          ),

          // --- My reminders --------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: Text(l10n.reminders, style: theme.textTheme.titleMedium),
          ),
          if (sorted.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.remindersEmpty, textAlign: TextAlign.center),
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
              onEdit: () => _edit(context, reminder),
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
    final theme = Theme.of(context);
    final enabled = reminder.enabled;
    final dim = enabled ? 1.0 : 0.5;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 4, 12),
          child: Row(
            children: [
              Opacity(
                opacity: dim,
                child: Text(
                  TimeOfDay(
                    hour: reminder.hour,
                    minute: reminder.minute,
                  ).format(context),
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Opacity(
                  opacity: dim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title.isEmpty
                            ? l10n.reminderDefaultTitle
                            : reminder.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(summary, style: theme.textTheme.bodySmall),
                      if (subjectName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.link, size: 14),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  subjectName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Switch(value: enabled, onChanged: onToggle),
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
                    child: Text(l10n.actionEdit),
                  ),
                  PopupMenuItem(
                    value: _ReminderMenu.delete,
                    child: Text(l10n.actionDelete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
