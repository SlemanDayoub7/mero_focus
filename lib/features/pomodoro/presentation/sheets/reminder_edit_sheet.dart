import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/services/reminder_notification_service.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/subject.dart';
import '../controllers/planner_providers.dart';
import '../controllers/reminders_provider.dart';

/// Name of an ISO weekday (1 = Monday ... 7 = Sunday).
String weekdayName(AppLocalizations l10n, int isoDay) {
  return switch (isoDay) {
    1 => l10n.weekday1,
    2 => l10n.weekday2,
    3 => l10n.weekday3,
    4 => l10n.weekday4,
    5 => l10n.weekday5,
    6 => l10n.weekday6,
    _ => l10n.weekday7,
  };
}

/// Week shown Saturday first, like the rest of the app.
const List<int> kWeekOrder = <int>[6, 7, 1, 2, 3, 4, 5];

/// Create or edit a reminder. [initial] with id 0 is a new reminder, which
/// is how the suggestions pre-fill the form.
class ReminderEditSheet extends ConsumerStatefulWidget {
  const ReminderEditSheet({super.key, required this.initial});

  final Reminder initial;

  @override
  ConsumerState<ReminderEditSheet> createState() => _ReminderEditSheetState();
}

class _ReminderEditSheetState extends ConsumerState<ReminderEditSheet> {
  late final TextEditingController _title = TextEditingController(
    text: widget.initial.title,
  );
  late TimeOfDay _time = TimeOfDay(
    hour: widget.initial.hour,
    minute: widget.initial.minute,
  );
  late ReminderRepeat _repeat = widget.initial.repeat;
  late final Set<int> _days = <int>{...widget.initial.weekdays};
  late DateTime? _date = widget.initial.date;
  late int? _subjectId = widget.initial.subjectId;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null && mounted) setState(() => _time = picked);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  bool get _valid {
    if (_repeat == ReminderRepeat.days) return _days.isNotEmpty;
    return true;
  }

  void _showPermissionError() {
    if (!mounted) return;
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.reminderNotificationsOff} ${l10n.errorGeneric}'),
        action: SnackBarAction(
          label: l10n.actionRetry,
          onPressed: () => unawaited(_retryPermission()),
        ),
      ),
    );
  }

  Future<void> _retryPermission() async {
    if (!mounted) return;
    final granted = await ref.read(reminderServiceProvider).requestPermission();
    ref.invalidate(notificationsEnabledProvider);
    if (!granted) _showPermissionError();
  }

  Future<void> _save() async {
    if (_saving || !mounted) return;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final date = _repeat == ReminderRepeat.once
          ? (_date ?? _defaultOnceDate())
          : null;
      final reminder = widget.initial.copyWith(
        title: _title.text.trim(),
        hour: _time.hour,
        minute: _time.minute,
        repeat: _repeat,
        weekdays: _days,
        date: date,
        subjectId: _subjectId,
        clearSubject: _subjectId == null,
        enabled: true,
      );
      await ref.read(remindersProvider.notifier).save(reminder);

      // Ask for the notification permission the first time it is needed.
      final service = ref.read(reminderServiceProvider);
      if (!await service.notificationsEnabled()) {
        if (!await service.requestPermission()) {
          ref.invalidate(notificationsEnabledProvider);
          _showPermissionError();
        } else {
          ref.invalidate(notificationsEnabledProvider);
        }
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.errorGeneric),
          action: SnackBarAction(
            label: l10n.actionRetry,
            onPressed: () => unawaited(_save()),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Today if the chosen time is still ahead, otherwise tomorrow.
  DateTime _defaultOnceDate() {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
      _time.hour,
      _time.minute,
    );
    return today.isAfter(now)
        ? DateTime(now.year, now.month, now.day)
        : DateTime(now.year, now.month, now.day + 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subjectsAsync = ref.watch(subjectsProvider);
    final subjects = subjectsAsync is AsyncData<List<Subject>>
        ? subjectsAsync.value
        : const <Subject>[];
    final linked = subjects.any((subject) => subject.id == _subjectId)
        ? _subjectId
        : null;
    final isNew = widget.initial.id <= 0;

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
          Text(
            isNew ? l10n.reminderAdd : l10n.reminderEdit,
            style: AppTypography.title,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _title,
            maxLines: 2,
            minLines: 1,
            style: AppTypography.body,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.reminderTitleLabel,
              hintText: l10n.reminderTitleHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.access_time),
            title: Text(l10n.reminderTime, style: AppTypography.body),
            trailing: Text(
              _time.format(context),
              style: AppTypography.title,
            ),
            onTap: () => unawaited(_pickTime()),
          ),
          SegmentedButton<ReminderRepeat>(
            segments: [
              ButtonSegment(
                value: ReminderRepeat.daily,
                label: Text(l10n.reminderRepeatDaily),
              ),
              ButtonSegment(
                value: ReminderRepeat.days,
                label: Text(l10n.reminderRepeatDays),
              ),
              ButtonSegment(
                value: ReminderRepeat.once,
                label: Text(l10n.reminderRepeatOnce),
              ),
            ],
            selected: {_repeat},
            onSelectionChanged: (selection) =>
                setState(() => _repeat = selection.first),
          ),
          if (_repeat == ReminderRepeat.days) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.touchTargetGap,
              runSpacing: AppSpacing.touchTargetGap,
              children: [
                for (final day in kWeekOrder)
                  Semantics(
                    button: true,
                    selected: _days.contains(day),
                    label: weekdayName(l10n, day),
                    child: FilterChip(
                      label: Text(
                        weekdayName(l10n, day),
                        style: AppTypography.label,
                      ),
                      selected: _days.contains(day),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _days.add(day);
                        } else {
                          _days.remove(day);
                        }
                      }),
                    ),
                  ),
              ],
            ),
          ],
          if (_repeat == ReminderRepeat.once)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(l10n.reminderDate, style: AppTypography.body),
              trailing: Text(
                _date == null
                    ? '${_defaultOnceDate().year}/${_defaultOnceDate().month}/${_defaultOnceDate().day}'
                    : '${_date!.year}/${_date!.month}/${_date!.day}',
                style: AppTypography.label,
              ),
              onTap: () => unawaited(_pickDate()),
            ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<int?>(
            initialValue: linked,
            decoration: InputDecoration(
              labelText: l10n.reminderLinkedTask,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem<int?>(
                value: null,
                child: Text(l10n.reminderNoLink),
              ),
              for (final subject in subjects)
                DropdownMenuItem<int?>(
                  value: subject.id,
                  child: Text(subject.name),
                ),
            ],
            onChanged: (value) => setState(() => _subjectId = value),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              TextButton(
                onPressed: _saving
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(l10n.actionCancel),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _valid && !_saving ? () => unawaited(_save()) : null,
                child: Text(_saving ? l10n.statusSaving : l10n.actionSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
