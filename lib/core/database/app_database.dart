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
  int get schemaVersion => 1;
}

/// Opens the on-device database file in the app documents directory.
Future<AppDatabase> openAppDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'mero_focus.sqlite'));
  return AppDatabase(NativeDatabase(file));
}
