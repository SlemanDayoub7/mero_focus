# Data Model (Drift Schema)

See ADR-0004 for why Drift was chosen, and ADR-0005 for the "raw data only" principle this design is built on.

## Tables

### `FocusSessions`
The raw record of every Pomodoro session. This table is the single source of truth for all statistics.

```dart
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get plannedDurationSeconds => integer()();
  IntColumn get actualDurationSeconds => integer()();
  IntColumn get sessionType => integer()(); // 0=work, 1=shortBreak, 2=longBreak
  BoolColumn get completed => boolean().withDefault(const Constant(true))();
  IntColumn get completionPercentage => integer().withDefault(const Constant(100))();
  IntColumn get tagId => integer().nullable().references(Tags, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [];
}

@TableIndex(name: 'idx_session_start', columns: {#startTime})
```

### `Tags`
Optional session categorization (study, work, reading...).

```dart
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get colorHex => text()();
}
```

### `Habits`
```dart
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  IntColumn get frequencyType => integer()(); // daily / weeklyXDays / customMask
  TextColumn get frequencyConfig => text()(); // simple JSON
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}
```

### `HabitLogs`
```dart
class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  DateTimeColumn get date => dateTime()(); // start of day only (00:00)
  BoolColumn get completed => boolean()();
  RealColumn get value => real().nullable()(); // for measurable habits

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date},
  ];
}

@TableIndex(name: 'idx_habitlog_date', columns: {#date})
```

### `AppLockRules`
```dart
class AppLockRules extends Table {
  TextColumn get packageName => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {packageName};
}
```

### `AppSettings`
Always a single row (id = 0).

```dart
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get workDurationSec => integer().withDefault(const Constant(1500))();
  IntColumn get shortBreakSec => integer().withDefault(const Constant(300))();
  IntColumn get longBreakSec => integer().withDefault(const Constant(900))();
  IntColumn get roundsBeforeLongBreak => integer().withDefault(const Constant(4))();
  TextColumn get themeId => text().withDefault(const Constant('default'))();
  TextColumn get backgroundId => text().withDefault(const Constant('default'))();
  TextColumn get whiteNoiseSoundId => text().nullable()();
  TextColumn get timerEndSoundId => text().withDefault(const Constant('default_bell'))();
  BoolColumn get appLockEnabled => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
```

## Core Principle: No Storage of Any "Mode/Level" State

See ADR-0005. Any future gamification feature is built as a computation layer on top of `FocusSessions` and `HabitLogs`, not as an additional state-storing table.

## Aggregation Query Examples (Statistics)

### Daily statistic
```dart
Future<List<DailyFocusStat>> getDailyStats(DateTime from, DateTime to) {
  final query = customSelect(
    '''
    SELECT date(start_time) as day, SUM(actual_duration_seconds) as total
    FROM focus_sessions
    WHERE start_time BETWEEN ? AND ? AND session_type = 0 AND completed = 1
    GROUP BY day ORDER BY day
    ''',
    variables: [Variable.withDateTime(from), Variable.withDateTime(to)],
    readsFrom: {focusSessions},
  );
  return query.map((row) => DailyFocusStat(
    day: DateTime.parse(row.read<String>('day')),
    totalSeconds: row.read<int>('total'),
  )).get();
}
```

> **Implementation note:** Drift stores `DateTime` as an integer (milliseconds), not as ISO text. When the first real statistics query is written, the SQLite date functions must be adapted (for example `datetime(start_time / 1000, 'unixepoch')` or an `expressed column`) instead of assuming `date(start_time)` works directly. This document is updated once the final query form is settled.

The same pattern applies to:
- **Hourly statistic:** `strftime('%H', start_time)` instead of `date(start_time)`.
- **Weekly statistic:** `strftime('%Y-%W', start_time)`.
- **Monthly statistic:** `strftime('%Y-%m', start_time)`.
- **Yearly statistic:** `strftime('%Y', start_time)`.
- **Custom range:** the same `WHERE start_time BETWEEN ? AND ?` clause without a daily `GROUP BY`, with a direct `SUM`.
