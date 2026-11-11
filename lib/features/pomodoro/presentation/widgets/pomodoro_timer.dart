import 'package:flutter/material.dart';

/// The countdown timer widget of the pomodoro feature.
class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({
    super.key,
    required this.remaining,
    required this.isRunning,
  });

  final Duration remaining;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    // TODO: render the remaining time and the start/pause controls.
    throw UnimplementedError();
  }
}
