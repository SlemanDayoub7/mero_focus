import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_focus/core/widgets/app_scaffold.dart';
import 'package:mero_focus/features/pomodoro/presentation/widgets/app_background.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/session_type.dart';
import '../controllers/planner_providers.dart';
import '../controllers/pomodoro_timer_controller.dart';
import '../controllers/timer_actions.dart';
import '../widgets/pomodoro_timer_display.dart';

/// Immersive full-screen timer: system bars hidden, large countdown, only the
/// essential buttons. Tap the exit button to return.
class TimerFullscreenPage extends ConsumerStatefulWidget {
  const TimerFullscreenPage({super.key});

  @override
  ConsumerState<TimerFullscreenPage> createState() =>
      _TimerFullscreenPageState();
}

class _TimerFullscreenPageState extends ConsumerState<TimerFullscreenPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    );
  }

  @override
  void dispose() {
    unawaited(
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final snapshot = ref.watch(pomodoroTimerProvider);
    final controller = ref.read(pomodoroTimerProvider.notifier);
    final activeTask = ref.watch(activeTaskProvider);
    final actions = buildTimerActions(snapshot, controller, l10n);

    final phaseLabel = switch (snapshot.phase) {
      SessionType.work => l10n.pomodoroWork,
      SessionType.shortBreak => l10n.pomodoroShortBreak,
      SessionType.longBreak => l10n.pomodoroLongBreak,
    };

    final secondaryLabel = actions.secondaryLabel;
    final onSecondary = actions.onSecondary;

    return AppScaffold(
      transparentBackground: true,
      // Immersive mode: SafeArea's top inset was leaving a black strip.
      applySafeArea: false,
      appBar: null,
      body: AppBackground(
        target: BackgroundTarget.timer,
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                tooltip: l10n.timerExitFullscreen,
                icon: const Icon(Icons.fullscreen_exit),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      phaseLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (activeTask != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          activeTask.title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    PomodoroTimerDisplay(snapshot: snapshot, size: 280),
                    const SizedBox(height: AppSpacing.lg),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Theme supplies the accessible 48 dp minimum and
                        // the filled style, so this stays the only primary
                        // action on screen.
                        FilledButton.icon(
                          icon: Icon(actions.primaryIcon),
                          label: Text(actions.primaryLabel),
                          onPressed: actions.onPrimary,
                        ),
                        if (secondaryLabel != null && onSecondary != null) ...[
                          const SizedBox(height: AppSpacing.touchTargetGap),
                          OutlinedButton(
                            onPressed: onSecondary,
                            child: Text(secondaryLabel),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
