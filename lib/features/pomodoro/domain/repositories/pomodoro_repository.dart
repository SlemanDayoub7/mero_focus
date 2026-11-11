import 'package:mero_focus/features/pomodoro/domain/entities/pomodoro_session.dart';

/// Contract for the pomodoro data operations.
abstract interface class PomodoroRepository {
  // TODO: return the stored sessions, newest first.
  Future<List<PomodoroSession>> getSessions();

  // TODO: persist a started session.
  Future<void> startSession(PomodoroSession session);

  // TODO: persist the changes of an existing session.
  Future<void> updateSession(PomodoroSession session);
}
