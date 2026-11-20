import 'package:drift/drift.dart';

import '../constants/defaults.dart';

/// Raw record of every focus session — the single source of truth for stats.
@TableIndex(name: 'idx_session_start', columns: {#startTime})
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get plannedDurationSeconds => integer()();
  IntColumn get actualDurationSeconds => integer()();
  IntColumn get sessionType => integer()();
  BoolColumn get completed => boolean().withDefault(const Constant(true))();
  IntColumn get completionPercentage =>
      integer().withDefault(const Constant(100))();
  IntColumn get tagId => integer().nullable().references(Tags, #id)();

  /// Snapshot of the subject/task shown with this session, so reports survive
  /// the deletion of the referenced records.
  TextColumn get label => text().withDefault(const Constant(''))();
  IntColumn get taskId => integer().nullable().references(Tasks, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [];
}

/// Optional categorization of focus sessions. Also used as study subjects.
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get colorHex => text()();
}

/// Planner tasks that can be attached to a focus session.
@TableIndex(name: 'idx_task_due_date', columns: {#dueDate})
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get subjectId => integer().nullable().references(Tags, #id)();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get estimatedPomodoros =>
      integer().withDefault(const Constant(1))();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [];
}

/// Habits being tracked.
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  IntColumn get frequencyType => integer()();
  TextColumn get frequencyConfig => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// Per-day completion records for habits.
@TableIndex(name: 'idx_habitlog_date', columns: {#date})
class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed => boolean()();
  RealColumn get value => real().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date},
  ];
}

/// Per-package rules for the optional app-lock feature.
class AppLockRules extends Table {
  TextColumn get packageName => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {packageName};
}

/// Single-row table (id = 0) holding user preferences.
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get workDurationSec =>
      integer().withDefault(const Constant(AppDefaults.workDurationSec))();
  IntColumn get shortBreakSec =>
      integer().withDefault(const Constant(AppDefaults.shortBreakSec))();
  IntColumn get longBreakSec =>
      integer().withDefault(const Constant(AppDefaults.longBreakSec))();
  IntColumn get roundsBeforeLongBreak => integer().withDefault(
    const Constant(AppDefaults.roundsBeforeLongBreak),
  )();
  IntColumn get maxDurationSec =>
      integer().withDefault(const Constant(AppDefaults.maxDurationSec))();
  IntColumn get dailyGoalMinutes =>
      integer().withDefault(const Constant(AppDefaults.dailyGoalMinutes))();
  BoolColumn get strictMode => boolean().withDefault(const Constant(false))();
  BoolColumn get countUp => boolean().withDefault(const Constant(false))();
  BoolColumn get studentMode => boolean().withDefault(const Constant(false))();
  BoolColumn get studentPromptSeen =>
      boolean().withDefault(const Constant(false))();
  TextColumn get themeId =>
      text().withDefault(const Constant(AppDefaults.themeId))();
  TextColumn get backgroundId =>
      text().withDefault(const Constant(AppDefaults.backgroundId))();
  TextColumn get whiteNoiseSoundId => text().nullable()();
  TextColumn get timerEndSoundId =>
      text().withDefault(const Constant(AppDefaults.timerEndSoundId))();
  BoolColumn get appLockEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
