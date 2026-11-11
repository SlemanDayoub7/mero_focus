import 'package:equatable/equatable.dart';

/// One pomodoro focus session.
class PomodoroSession extends Equatable {
  const PomodoroSession({
    required this.id,
    required this.startedAt,
    required this.focusMinutes,
    required this.breakMinutes,
    this.endedAt,
    this.isCompleted = false,
  });

  final String id;
  final DateTime startedAt;
  final int focusMinutes;
  final int breakMinutes;
  final DateTime? endedAt;
  final bool isCompleted;

  @override
  List<Object?> get props => [
    id,
    startedAt,
    focusMinutes,
    breakMinutes,
    endedAt,
    isCompleted,
  ];
}
