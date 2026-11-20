import 'package:drift/drift.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;

import '../../domain/entities/planner_preferences.dart';
import '../../domain/repositories/planner_preferences_repository.dart';

/// Reads and writes the Pomodoro slice of the single `AppSettings` row.
class PlannerPreferencesRepositoryImpl implements PlannerPreferencesRepository {
  const PlannerPreferencesRepositoryImpl(this._database);

  final db.AppDatabase _database;

  @override
  Stream<PlannerPreferences> watchPreferences() {
    final query = _database.select(_database.appSettings)
      ..where((row) => row.id.equals(0));
    return query.watch().map(
      (rows) =>
          rows.isEmpty ? const PlannerPreferences() : _toEntity(rows.first),
    );
  }

  @override
  Future<void> savePreferences(PlannerPreferences preferences) async {
    final existing = await (_database.select(
      _database.appSettings,
    )..where((row) => row.id.equals(0))).getSingleOrNull();
    final companion = _toCompanion(preferences);
    if (existing == null) {
      await _database.into(_database.appSettings).insert(companion);
      return;
    }
    await (_database.update(
      _database.appSettings,
    )..where((row) => row.id.equals(0))).write(companion);
  }

  db.AppSettingsCompanion _toCompanion(PlannerPreferences preferences) {
    return db.AppSettingsCompanion(
      // `INTEGER PRIMARY KEY` auto-assigns a rowid when omitted, so the
      // documented single-row id must be supplied explicitly.
      id: const Value(0),
      workDurationSec: Value(preferences.focusDuration.inSeconds),
      shortBreakSec: Value(preferences.shortBreakDuration.inSeconds),
      longBreakSec: Value(preferences.longBreakDuration.inSeconds),
      roundsBeforeLongBreak: Value(preferences.roundsBeforeLongBreak),
      maxDurationSec: Value(preferences.maxDuration.inSeconds),
      dailyGoalMinutes: Value(preferences.dailyGoalMinutes),
      strictMode: Value(preferences.strictMode),
      countUp: Value(preferences.countUp),
      whiteNoiseSoundId: Value(preferences.whiteNoiseSoundId),
      backgroundId: Value(preferences.backgroundId),
      studentMode: Value(preferences.studentMode),
      studentPromptSeen: Value(preferences.studentPromptSeen),
    );
  }

  PlannerPreferences _toEntity(db.AppSetting row) => PlannerPreferences(
    focusDuration: Duration(seconds: row.workDurationSec),
    shortBreakDuration: Duration(seconds: row.shortBreakSec),
    longBreakDuration: Duration(seconds: row.longBreakSec),
    roundsBeforeLongBreak: row.roundsBeforeLongBreak,
    maxDuration: Duration(seconds: row.maxDurationSec),
    dailyGoalMinutes: row.dailyGoalMinutes,
    strictMode: row.strictMode,
    countUp: row.countUp,
    whiteNoiseSoundId: row.whiteNoiseSoundId,
    backgroundId: row.backgroundId,
    studentMode: row.studentMode,
    studentPromptSeen: row.studentPromptSeen,
  );
}
