import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/entities/timer_snapshot.dart';
import 'pomodoro_timer_controller.dart';

/// The buttons that make sense for the current timer state. Shared by the
/// normal timer page and the full-screen mode so both behave identically.
class TimerActionSet {
  const TimerActionSet({
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
}

TimerActionSet buildTimerActions(
  TimerSnapshot snapshot,
  PomodoroTimerController controller,
  AppLocalizations l10n,
) {
  final isWork = snapshot.phase == SessionType.work;

  if (snapshot.isBreakOffer) {
    return TimerActionSet(
      primaryLabel: l10n.timerStartBreak,
      primaryIcon: Icons.free_breakfast_outlined,
      onPrimary: controller.startBreak,
      secondaryLabel: l10n.timerSkipBreak,
      onSecondary: controller.skipBreak,
    );
  }
  if (snapshot.isRunning) {
    return TimerActionSet(
      primaryLabel: l10n.timerPause,
      primaryIcon: Icons.pause,
      onPrimary: controller.pause,
      secondaryLabel: isWork ? null : l10n.timerSkipBreak,
      onSecondary: isWork ? null : controller.skipBreak,
    );
  }
  if (snapshot.isPaused) {
    return TimerActionSet(
      primaryLabel: l10n.timerStart,
      primaryIcon: Icons.play_arrow,
      onPrimary: controller.start,
      secondaryLabel: isWork ? l10n.timerStop : l10n.timerSkipBreak,
      onSecondary: isWork ? controller.stop : controller.skipBreak,
    );
  }
  return TimerActionSet(
    primaryLabel: l10n.timerStart,
    primaryIcon: Icons.play_arrow,
    onPrimary: controller.start,
  );
}
