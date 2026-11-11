import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:mero_focus/features/pomodoro/domain/repositories/pomodoro_repository.dart';

/// Pauses the running pomodoro session.
class PauseSession extends UseCase<void, PomodoroSession> {
  const PauseSession(this._repository);

  final PomodoroRepository _repository;

  @override
  Future<void> call(PomodoroSession params) {
    // TODO: delegate to PomodoroRepository.updateSession.
    throw UnimplementedError();
  }
}
