import '../entities/focus_session.dart';
import '../repositories/pomodoro_repository.dart';

/// Stores a finished phase as raw data for the future statistics feature.
class SaveCompletedSession {
  const SaveCompletedSession(this._repository);

  final PomodoroRepository _repository;

  Future<int> call(FocusSession session) => _repository.saveSession(session);
}
