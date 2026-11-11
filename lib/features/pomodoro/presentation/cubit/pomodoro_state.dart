import 'package:equatable/equatable.dart';

/// Base state of the pomodoro feature.
sealed class PomodoroState extends Equatable {
  const PomodoroState();

  @override
  List<Object?> get props => [];
}

/// Initial state, before any session starts.
final class PomodoroInitial extends PomodoroState {
  const PomodoroInitial();
}

// TODO: add PomodoroRunning, PomodoroPaused, PomodoroCompleted and
// PomodoroError states.
