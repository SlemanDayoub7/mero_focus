import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/constants/defaults.dart';
import 'package:mero_focus/core/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a v1 database is upgraded to v2 without losing sessions', () async {
    final file = File(
      p.join(
        Directory.systemTemp.path,
        'mero_focus_migration_${DateTime.now().microsecondsSinceEpoch}.sqlite',
      ),
    );
    addTearDown(() async {
      if (await file.exists()) await file.delete();
    });

    final legacy = sqlite3.open(file.path);
    legacy.execute(
      'CREATE TABLE tags ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT NOT NULL, '
      'color_hex TEXT NOT NULL)',
    );
    legacy.execute(
      'CREATE TABLE focus_sessions ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'start_time INTEGER NOT NULL, '
      'end_time INTEGER, '
      'planned_duration_seconds INTEGER NOT NULL, '
      'actual_duration_seconds INTEGER NOT NULL, '
      'session_type INTEGER NOT NULL, '
      'completed INTEGER NOT NULL DEFAULT 1, '
      'completion_percentage INTEGER NOT NULL DEFAULT 100, '
      'tag_id INTEGER REFERENCES tags (id))',
    );
    legacy.execute(
      'CREATE TABLE app_settings ('
      'id INTEGER PRIMARY KEY DEFAULT 0, '
      'work_duration_sec INTEGER NOT NULL DEFAULT 1500, '
      'short_break_sec INTEGER NOT NULL DEFAULT 300, '
      'long_break_sec INTEGER NOT NULL DEFAULT 900, '
      'rounds_before_long_break INTEGER NOT NULL DEFAULT 4, '
      "theme_id TEXT NOT NULL DEFAULT 'default', "
      "background_id TEXT NOT NULL DEFAULT 'default', "
      'white_noise_sound_id TEXT, '
      "timer_end_sound_id TEXT NOT NULL DEFAULT 'default_bell', "
      'app_lock_enabled INTEGER NOT NULL DEFAULT 0)',
    );
    // Drift stores DateTime values as Unix seconds, not milliseconds.
    final startedAt = DateTime(2026, 3, 1, 10).millisecondsSinceEpoch ~/ 1000;
    legacy.execute(
      'INSERT INTO focus_sessions '
      '(start_time, planned_duration_seconds, actual_duration_seconds, session_type) '
      'VALUES ($startedAt, 1500, 1500, 0)',
    );
    legacy.execute('PRAGMA user_version = 1');
    legacy.close();

    final database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);

    final tables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'tasks'",
        )
        .get();
    expect(tables, isNotEmpty);

    final settings = (await database.select(database.appSettings).get());
    expect(settings, isEmpty);

    final sessionColumns = await database
        .customSelect('PRAGMA table_info(focus_sessions)')
        .get();
    final names = sessionColumns
        .map((row) => row.read<String>('name'))
        .toList();
    expect(names, contains('label'));
    expect(names, contains('task_id'));
    final preserved =
        (await database.select(database.focusSessions).get()).single;
    expect(preserved.startTime, DateTime(2026, 3, 1, 10));
    expect(preserved.label, isEmpty);
    expect(preserved.taskId, isNull);

    final settingColumns = await database
        .customSelect('PRAGMA table_info(app_settings)')
        .get();
    final settingNames = settingColumns
        .map((row) => row.read<String>('name'))
        .toList();
    expect(settingNames, contains('max_duration_sec'));
    expect(settingNames, contains('daily_goal_minutes'));
    expect(settingNames, contains('strict_mode'));
    expect(settingNames, contains('count_up'));
    expect(settingNames, contains('student_mode'));
    expect(settingNames, contains('student_prompt_seen'));

    await database
        .into(database.appSettings)
        .insert(AppSettingsCompanion.insert());
    final savedSettings =
        (await database.select(database.appSettings).get()).single;
    expect(savedSettings.maxDurationSec, AppDefaults.maxDurationSec);
    expect(savedSettings.dailyGoalMinutes, AppDefaults.dailyGoalMinutes);
  });
}
