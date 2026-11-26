import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/session_type.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../controllers/timer_extras_settings.dart';
import '../formatting/duration_labels.dart';
import '../widgets/minutes_picker_dialog.dart';

/// Runs a settings write and reports failures in plain language with a retry
/// action, instead of letting an `unawaited` future fail silently.
Future<void> _runWithFeedback(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (error, stackTrace) {
    debugPrint('Timer settings action failed: $error\n$stackTrace');
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    final l10n = context.l10n;
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.errorGeneric),
        action: SnackBarAction(
          label: l10n.actionRetry,
          onPressed: () => unawaited(_runWithFeedback(context, action)),
        ),
      ),
    );
  }
}

/// Opens the wheel picker for one phase and stores the result. The timer
/// controller listens to the preferences stream and refreshes the idle
/// countdown by itself.
Future<void> editPhaseDuration(
  BuildContext context,
  WidgetRef ref,
  SessionType phase,
  String label,
) async {
  await _runWithFeedback(context, () async {
    final prefs = await ref.read(plannerPreferencesProvider.future);
    if (!context.mounted) return;

    final current = switch (phase) {
      SessionType.work => prefs.focusDuration,
      SessionType.shortBreak => prefs.shortBreakDuration,
      SessionType.longBreak => prefs.longBreakDuration,
    };
    final minutes = await showMinutesPicker(
      context,
      title: label,
      initialMinutes: current.inMinutes,
    );
    if (minutes == null || !context.mounted) return;

    final duration = Duration(minutes: minutes);
    final next = switch (phase) {
      SessionType.work => prefs.copyWith(focusDuration: duration),
      SessionType.shortBreak => prefs.copyWith(shortBreakDuration: duration),
      SessionType.longBreak => prefs.copyWith(longBreakDuration: duration),
    };
    await ref.read(plannerActionsProvider).savePreferences(next);
  });
}

/// Timer settings: focus / short break / long break durations and how many
/// rounds pass before a long break.
class TimerSettingsSheet extends ConsumerWidget {
  const TimerSettingsSheet({super.key});

  static const int _maxRounds = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final prefsAsync = ref.watch(plannerPreferencesProvider);

    if (prefsAsync is! AsyncData<PlannerPreferences>) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.statusLoading,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    final prefs = prefsAsync.value;

    Widget durationTile(SessionType phase, String label, Duration value) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        trailing: Text(
          value.labelOf(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onTap: () => unawaited(editPhaseDuration(context, ref, phase, label)),
      );
    }

    void setRounds(int value) {
      unawaited(
        _runWithFeedback(
          context,
          () => ref
              .read(plannerActionsProvider)
              .savePreferences(prefs.copyWith(roundsBeforeLongBreak: value)),
        ),
      );
    }

    final fewerRounds = prefs.roundsBeforeLongBreak - 1;
    final moreRounds = prefs.roundsBeforeLongBreak + 1;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.timerSettings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            durationTile(
              SessionType.work,
              l10n.pomodoroWork,
              prefs.focusDuration,
            ),
            durationTile(
              SessionType.shortBreak,
              l10n.pomodoroShortBreak,
              prefs.shortBreakDuration,
            ),
            durationTile(
              SessionType.longBreak,
              l10n.pomodoroLongBreak,
              prefs.longBreakDuration,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.timerLongBreakEvery,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  // The target value is a meaningful, localised label for
                  // the icon-only control.
                  tooltip: '${l10n.timerLongBreakEvery}: $fewerRounds',
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: prefs.roundsBeforeLongBreak > 1
                      ? () => setRounds(fewerRounds)
                      : null,
                ),
                Text(
                  '${prefs.roundsBeforeLongBreak}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  tooltip: '${l10n.timerLongBreakEvery}: $moreRounds',
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: prefs.roundsBeforeLongBreak < _maxRounds
                      ? () => setRounds(moreRounds)
                      : null,
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            const _EndSoundSwitch(),
          ],
        ),
      ),
    );
  }
}

/// Only the timer-specific sound switch stays here; ambience and background
/// are chosen from Settings.
class _EndSoundSwitch extends ConsumerWidget {
  const _EndSoundSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(timerExtrasProvider).endSoundEnabled;

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.soundEndTimer),
      value: enabled,
      onChanged: (value) => unawaited(
        _runWithFeedback(
          context,
          () =>
              ref.read(timerExtrasProvider.notifier).setEndSoundEnabled(value),
        ),
      ),
    );
  }
}
