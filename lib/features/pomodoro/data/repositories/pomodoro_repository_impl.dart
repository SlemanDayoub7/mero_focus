import 'package:drift/drift.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;

import '../../domain/entities/focus_session.dart';
import '../../domain/entities/session_type.dart';
import '../../domain/repositories/pomodoro_repository.dart';

/// Drift-backed implementation of the pomodoro persistence port.
class PomodoroRepositoryImpl implements PomodoroRepository {
  const PomodoroRepositoryImpl(this._database);

  final db.AppDatabase _database;

  @override
  Future<int> saveSession(FocusSession session) {
    return _database.into(_database.focusSessions).insert(
          db.FocusSessionsCompanion.insert(
            startTime: session.startTime,
            endTime: Value(session.endTime),
            plannedDurationSeconds: session.plannedDuration.inSeconds,
            actualDurationSeconds: session.actualDuration.inSeconds,
            sessionType: session.sessionType.storageValue,
            completed: Value(session.completed),
            completionPercentage: Value(session.completionPercentage),
          ),
        );
  }

  @override
  Future<List<FocusSession>> getSessions() async {
    final query = _database.select(_database.focusSessions)
      ..orderBy([(row) => OrderingTerm.desc(row.startTime)]);
    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  FocusSession _toEntity(db.FocusSession row) {
    return FocusSession(
      id: row.id,
      startTime: row.startTime,
      endTime: row.endTime ?? row.startTime,
      plannedDuration: Duration(seconds: row.plannedDurationSeconds),
      actualDuration: Duration(seconds: row.actualDurationSeconds),
      sessionType: SessionType.fromStorage(row.sessionType),
      completed: row.completed,
      completionPercentage: row.completionPercentage,
    );
  }
}
