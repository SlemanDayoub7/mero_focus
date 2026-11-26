import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/defaults.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/planner_preferences.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/entities/timer_snapshot.dart';
import '../controllers/planner_providers.dart';
import '../controllers/pomodoro_timer_controller.dart';
import '../controllers/subtasks_provider.dart';
import '../controllers/timer_actions.dart';
import '../sheets/task_picker_sheet.dart';
import '../sheets/timer_settings_sheet.dart';
import '../widgets/phase_indicator.dart';
import '../widgets/pomodoro_timer_display.dart';
import '../widgets/timer_controls.dart';
import 'timer_fullscreen_page.dart';

/// The Pomodoro timer screen. All state lives in `pomodoroTimerProvider`;
/// this widget only renders it and forwards user intents to the controller.
///
/// Flow: Start -> Pause -> (Resume | End). When a focus phase finishes the
/// break is offered (Start break | Skip break). The single filled button is
/// the dominant action; configuration lives in a secondary group below it.
class PomodoroTimerPage extends ConsumerWidget {
  const PomodoroTimerPage({super.key});

  void _pickTask(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const TaskPickerSheet(),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const TimerSettingsSheet(),
    );
  }

  Future<void> _openFullscreen(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const TimerFullscreenPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(pomodoroTimerProvider);
    final controller = ref.read(pomodoroTimerProvider.notifier);
    final activeTask = ref.watch(activeTaskProvider);
    final activeSubtask = ref.watch(activeSubtaskProvider);
    final prefsAsync = ref.watch(plannerPreferencesProvider);
    final prefs = prefsAsync is AsyncData<PlannerPreferences>
        ? prefsAsync.value
        : null;
    final l10n = context.l10n;

    String labelOf(SessionType type) => switch (type) {
      SessionType.work => l10n.pomodoroWork,
      SessionType.shortBreak => l10n.pomodoroShortBreak,
      SessionType.longBreak => l10n.pomodoroLongBreak,
    };

    final phaseLabel = labelOf(snapshot.phase);
    final canEdit =
        snapshot.status == TimerStatus.idle || snapshot.isBreakOffer;

    final actions = buildTimerActions(snapshot, controller, l10n);

    return AppScaffold(
      transparentBackground: true,
      appBar: null,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activeTask != null) ...[
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: context.colors.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: const Icon(Icons.task_alt, size: 20),
                      title: Text(activeTask.title),
                      subtitle: activeSubtask == null
                          ? null
                          : Text(activeSubtask.name),
                      onTap: () => _pickTask(context),
                      trailing: IconButton(
                        tooltip: l10n.actionClear,
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => ref
                            .read(activeTaskIdProvider.notifier)
                            .select(null),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                PhaseIndicator(
                  phase: snapshot.phase,
                  completedRounds: snapshot.completedRounds,
                  phaseLabel: phaseLabel,
                  roundLabel: l10n.timerRound(snapshot.completedRounds + 1),
                  roundsBeforeLongBreak:
                      prefs?.roundsBeforeLongBreak ??
                      AppDefaults.roundsBeforeLongBreak,
                ),
                const SizedBox(height: AppSpacing.lg),
                const SizedBox(height: AppSpacing.md),
                PomodoroTimerDisplay(
                  snapshot: snapshot,
                  onTap: canEdit
                      ? () => unawaited(
                          editPhaseDuration(
                            context,
                            ref,
                            snapshot.phase,
                            phaseLabel,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TimerControls(
                  primaryLabel: actions.primaryLabel,
                  primaryIcon: actions.primaryIcon,
                  onPrimary: actions.onPrimary,
                  secondaryLabel: actions.secondaryLabel,
                  onSecondary: actions.onSecondary,
                ),
                const SizedBox(height: AppSpacing.sm),
                _SecondaryActions(
                  onPickTask: () => _pickTask(context),
                  onFullscreen: () => unawaited(_openFullscreen(context)),
                  onSettings: () => _openSettings(context),
                  onPermissions: () =>
                      AppRouter.toBackgroundPermissions(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A visually quiet group for everything that is not the timer's primary
/// action. Each control keeps a 48 dp target and a localised tooltip, so the
/// icons are labelled for both sighted and screen-reader users.
class _SecondaryActions extends StatelessWidget {
  const _SecondaryActions({
    required this.onPickTask,
    required this.onFullscreen,
    required this.onSettings,
    required this.onPermissions,
  });

  final VoidCallback onPickTask;
  final VoidCallback onFullscreen;
  final VoidCallback onSettings;
  final VoidCallback onPermissions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      container: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: l10n.taskPick,
            icon: const Icon(Icons.add_task),
            onPressed: onPickTask,
          ),
          IconButton(
            tooltip: l10n.timerFullscreen,
            icon: const Icon(Icons.fullscreen),
            onPressed: onFullscreen,
          ),
          IconButton(
            tooltip: l10n.timerSettings,
            icon: const Icon(Icons.tune),
            onPressed: onSettings,
          ),
          IconButton(
            tooltip: l10n.backgroundPermissions,
            icon: const Icon(Icons.settings_overscan_outlined),
            onPressed: onPermissions,
          ),
        ],
      ),
    );
  }
}
