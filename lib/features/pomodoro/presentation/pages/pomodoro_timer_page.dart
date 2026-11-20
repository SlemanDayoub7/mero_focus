import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/session_type.dart';
import '../controllers/pomodoro_timer_controller.dart';
import '../sheets/task_picker_sheet.dart';
import '../widgets/phase_indicator.dart';
import '../widgets/pomodoro_timer_display.dart';
import '../widgets/timer_controls.dart';

/// The Pomodoro timer screen. All state lives in `pomodoroTimerProvider`;
/// this widget only renders it and forwards user intents to the controller.
class PomodoroTimerPage extends ConsumerWidget {
  const PomodoroTimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(pomodoroTimerProvider);
    final controller = ref.read(pomodoroTimerProvider.notifier);
    final l10n = context.l10n;

    final phaseLabel = switch (snapshot.phase) {
      SessionType.work => l10n.pomodoroWork,
      SessionType.shortBreak => l10n.pomodoroShortBreak,
      SessionType.longBreak => l10n.pomodoroLongBreak,
    };

    return AppScaffold(
      appBar: AppAppBar(
        title: l10n.pomodoro,
        actions: [
          IconButton(
            tooltip: l10n.taskPick,
            icon: const Icon(Icons.playlist_add_check_circle_outlined),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const TaskPickerSheet(),
            ),
          ),
          IconButton(
            tooltip: l10n.backgroundPermissions,
            icon: const Icon(Icons.settings_overscan_outlined),
            onPressed: () => AppRouter.toBackgroundPermissions(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PhaseIndicator(
                phase: snapshot.phase,
                completedRounds: snapshot.completedRounds,
                phaseLabel: phaseLabel,
                roundLabel: l10n.timerRound(snapshot.completedRounds + 1),
              ),
              const SizedBox(height: AppSpacing.xl),
              PomodoroTimerDisplay(snapshot: snapshot, phaseLabel: phaseLabel),
              const SizedBox(height: AppSpacing.xl),
              TimerControls(
                isRunning: snapshot.isRunning,
                onStart: controller.start,
                onPause: controller.pause,
                onReset: controller.reset,
                startLabel: l10n.timerStart,
                pauseLabel: l10n.timerPause,
                resetLabel: l10n.timerReset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
