import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/session_type.dart';
import '../controllers/planner_actions.dart';
import '../../data/services/audio_white_noise.dart';
import '../controllers/planner_providers.dart';
import '../controllers/timer_extras_settings.dart';
import '../formatting/duration_labels.dart';
import '../widgets/minutes_picker_dialog.dart';

/// Opens the wheel picker for one phase and stores the result. The timer
/// controller listens to the preferences stream and refreshes the idle
/// countdown by itself.
Future<void> editPhaseDuration(
  BuildContext context,
  WidgetRef ref,
  SessionType phase,
  String label,
) async {
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
  if (minutes == null) return;

  final duration = Duration(minutes: minutes);
  final next = switch (phase) {
    SessionType.work => prefs.copyWith(focusDuration: duration),
    SessionType.shortBreak => prefs.copyWith(shortBreakDuration: duration),
    SessionType.longBreak => prefs.copyWith(longBreakDuration: duration),
  };
  await ref.read(plannerActionsProvider).savePreferences(next);
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
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final prefs = prefsAsync.value;

    Widget durationTile(SessionType phase, String label, Duration value) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        trailing: Text(
          value.labelOf(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onTap: () => unawaited(editPhaseDuration(context, ref, phase, label)),
      );
    }

    void setRounds(int value) {
      unawaited(
        ref
            .read(plannerActionsProvider)
            .savePreferences(prefs.copyWith(roundsBeforeLongBreak: value)),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.timerSettings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            durationTile(SessionType.work, l10n.pomodoroWork, prefs.focusDuration),
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
                Expanded(child: Text(l10n.timerLongBreakEvery)),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: prefs.roundsBeforeLongBreak > 1
                      ? () => setRounds(prefs.roundsBeforeLongBreak - 1)
                      : null,
                ),
                Text(
                  '${prefs.roundsBeforeLongBreak}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: prefs.roundsBeforeLongBreak < _maxRounds
                      ? () => setRounds(prefs.roundsBeforeLongBreak + 1)
                      : null,
                ),
              ],
            ),
            const Divider(height: 32),
            _SoundSection(prefs: prefs),
            const Divider(height: 32),
            const _BackgroundSection(),
          ],
        ),
      ),
    );
  }
}

/// Ambient sound choice + the end-of-timer sound switch.
class _SoundSection extends ConsumerWidget {
  const _SoundSection({required this.prefs});

  final PlannerPreferences prefs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final extras = ref.watch(timerExtrasProvider);

    String nameOf(String id) => switch (id) {
      AmbientSounds.white => l10n.soundWhite,
      AmbientSounds.pink => l10n.soundPink,
      _ => l10n.soundBrown,
    };

    void select(String? id) {
      final next = id == null
          ? prefs.copyWith(clearWhiteNoiseSoundId: true)
          : prefs.copyWith(whiteNoiseSoundId: id);
      unawaited(ref.read(plannerActionsProvider).savePreferences(next));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsSoundSection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(l10n.soundNone),
              selected: prefs.whiteNoiseSoundId == null,
              onSelected: (_) => select(null),
            ),
            for (final id in AmbientSounds.all)
              ChoiceChip(
                label: Text(nameOf(id)),
                selected: prefs.whiteNoiseSoundId == id,
                onSelected: (_) => select(id),
              ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.soundEndTimer),
          value: extras.endSoundEnabled,
          onChanged: (value) => unawaited(
            ref.read(timerExtrasProvider.notifier).setEndSoundEnabled(value),
          ),
        ),
      ],
    );
  }
}

/// Gallery background for the timer (and optionally the tasks screen).
class _BackgroundSection extends ConsumerWidget {
  const _BackgroundSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final extras = ref.watch(timerExtrasProvider);
    final notifier = ref.read(timerExtrasProvider.notifier);
    final hasImage = extras.backgroundPath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsBackgroundSection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.backgroundPick),
                onPressed: () => unawaited(notifier.pickBackground()),
              ),
            ),
            if (hasImage) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: l10n.backgroundRemove,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => unawaited(notifier.clearBackground()),
              ),
            ],
          ],
        ),
        if (hasImage) ...[
          const SizedBox(height: 8),
          SegmentedButton<BackgroundScope>(
            segments: [
              ButtonSegment(
                value: BackgroundScope.timerOnly,
                label: Text(l10n.backgroundTimerOnly),
              ),
              ButtonSegment(
                value: BackgroundScope.timerAndTasks,
                label: Text(l10n.backgroundTimerAndTasks),
              ),
            ],
            selected: {extras.scope},
            onSelectionChanged: (selection) =>
                unawaited(notifier.setScope(selection.first)),
          ),
        ],
      ],
    );
  }
}
