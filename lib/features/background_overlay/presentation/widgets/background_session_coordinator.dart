import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../home_widgets/presentation/widgets/home_widget_bridge.dart';
import '../../../pomodoro/domain/entities/session_type.dart';
import '../../../pomodoro/presentation/controllers/pomodoro_timer_controller.dart';
import '../../domain/entities/overlay_timer_data.dart';
import '../controllers/background_session_controller.dart';

/// Observes app lifecycle and timer state, then drives the background session
/// controller. It contains no platform calls and is therefore easy to reason
/// about; all effects live behind the controller's ports.
class BackgroundSessionCoordinator extends ConsumerStatefulWidget {
  const BackgroundSessionCoordinator({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BackgroundSessionCoordinator> createState() =>
      _BackgroundSessionCoordinatorState();
}

class _BackgroundSessionCoordinatorState
    extends ConsumerState<BackgroundSessionCoordinator>
    with WidgetsBindingObserver {
  bool _appInBackground = false;
  bool _firstSyncScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final backgrounded = lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.hidden ||
        lifecycle == AppLifecycleState.detached;
    if (backgrounded != _appInBackground) {
      setState(() => _appInBackground = backgrounded);
    }
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(pomodoroTimerProvider);
    ref.listen(pomodoroTimerProvider, (_, _) => _sync());
    ref.listen(overlayEnabledProvider, (_, _) => _sync());

    if (!_firstSyncScheduled) {
      _firstSyncScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
    }

    return HomeWidgetBridge(child: widget.child);
  }

  void _sync() {
    if (!mounted) return;
    final snapshot = ref.read(pomodoroTimerProvider);
    final l10n = context.l10n;
    final phaseLabel = switch (snapshot.phase) {
      SessionType.work => l10n.pomodoroWork,
      SessionType.shortBreak => l10n.pomodoroShortBreak,
      SessionType.longBreak => l10n.pomodoroLongBreak,
    };

    final overlayData = OverlayTimerData(
      remainingSeconds: snapshot.remaining.inSeconds,
      phaseLabel: phaseLabel,
      timeLabel: l10n.overlayTimeLabel,
    );

    unawaited(
      ref.read(backgroundSessionProvider.notifier).sync(
            timerRunning: snapshot.isRunning,
            appInBackground: _appInBackground,
            // The notification shows the phase and the live time (MM:SS).
            notificationTitle: phaseLabel,
            notificationText: overlayData.formattedTime,
            overlayData: overlayData,
          ),
    );
  }
}
