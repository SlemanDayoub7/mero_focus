import '../entities/focus_session.dart';

/// Persistence port for raw focus-session data (ADR-0005).
abstract class PomodoroRepository {
  Future<int> saveSession(FocusSession session);

  Future<List<FocusSession>> getSessions();
}
