import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:mero_focus/features/pomodoro/domain/repositories/pomodoro_repository.dart';

/// Completes a pomodoro session and stores its result.
class CompleteSession extends UseCase<void, PomodoroSession> {
  const CompleteSession(this._repository);

  final PomodoroRepository _repository;

  @override
  Future<void> call(PomodoroSession params) {
    // TODO: delegate to PomodoroRepository.updateSession.
    throw UnimplementedError();
  }
}
