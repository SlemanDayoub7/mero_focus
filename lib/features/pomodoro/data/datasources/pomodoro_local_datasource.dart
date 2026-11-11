import 'package:hive/hive.dart';

import 'package:mero_focus/features/pomodoro/data/models/pomodoro_session_model.dart';

/// Local (Hive) data source for pomodoro sessions.
class PomodoroLocalDataSource {
  const PomodoroLocalDataSource(this._box);

  final Box<PomodoroSessionModel> _box;

  // TODO: read every stored session.
  Future<List<PomodoroSessionModel>> getSessions() =>
      throw UnimplementedError();

  // TODO: insert or replace one session.
  Future<void> putSession(PomodoroSessionModel model) =>
      throw UnimplementedError();
}
