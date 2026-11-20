import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/defaults.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// The single local database for the whole app (ADR-0004).
@DriftDatabase(
  tables: [
    FocusSessions,
    Tags,
    Tasks,
    Habits,
    HabitLogs,
    AppLockRules,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// An in-memory instance for unit tests.
  AppDatabase.forTesting() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from == 1 && to == 2) {
        // Only the new table/index are created; existing tables (and their
        // indexes) are migrated with explicit `addColumn` calls below.
        await m.createTable(tasks);
        await m.create(idxTaskDueDate);
        await m.addColumn(focusSessions, focusSessions.label);
        await m.addColumn(focusSessions, focusSessions.taskId);
        await m.addColumn(appSettings, appSettings.maxDurationSec);
        await m.addColumn(appSettings, appSettings.dailyGoalMinutes);
        await m.addColumn(appSettings, appSettings.strictMode);
        await m.addColumn(appSettings, appSettings.countUp);
        await m.addColumn(appSettings, appSettings.studentMode);
        await m.addColumn(appSettings, appSettings.studentPromptSeen);
      }
    },
  );
}

/// Opens the on-device database file in the app documents directory.
Future<AppDatabase> openAppDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'mero_focus.sqlite'));
  return AppDatabase(NativeDatabase(file));
}
