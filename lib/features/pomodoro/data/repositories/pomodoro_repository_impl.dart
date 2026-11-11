import 'package:mero_focus/features/pomodoro/data/datasources/pomodoro_local_datasource.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:mero_focus/features/pomodoro/domain/repositories/pomodoro_repository.dart';

/// Hive-backed implementation of [PomodoroRepository].
class PomodoroRepositoryImpl implements PomodoroRepository {
  const PomodoroRepositoryImpl(this._localDataSource);

  final PomodoroLocalDataSource _localDataSource;

  @override
  Future<void> startSession(PomodoroSession session) {
    // TODO: map the entity to PomodoroSessionModel and persist it.
    throw UnimplementedError();
  }

  @override
  Future<void> updateSession(PomodoroSession session) {
    // TODO: map the entity to PomodoroSessionModel and persist it.
    throw UnimplementedError();
  }

  @override
  Future<List<PomodoroSession>> getSessions() {
    // TODO: read from Hive and map the models back to entities.
    throw UnimplementedError();
  }
}
