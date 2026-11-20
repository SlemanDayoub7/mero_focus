import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/constants/defaults.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;
import 'package:mero_focus/features/pomodoro/data/repositories/planner_preferences_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/planner_preferences.dart';

void main() {
  test(
    'falls back to documented defaults when no settings row exists',
    () async {
      final database = db.AppDatabase.forTesting();
      addTearDown(database.close);
      final repository = PlannerPreferencesRepositoryImpl(database);

      final preferences = await repository.watchPreferences().first;

      expect(preferences.focusDuration.inSeconds, AppDefaults.workDurationSec);
      expect(preferences.dailyGoalMinutes, AppDefaults.dailyGoalMinutes);
      expect(preferences.strictMode, isFalse);
      expect(preferences.whiteNoiseSoundId, isNull);
    },
  );

  test('saves planner settings without overwriting other settings', () async {
    final database = db.AppDatabase.forTesting();
    addTearDown(database.close);
    final repository = PlannerPreferencesRepositoryImpl(database);
    final insertedId = await database
        .into(database.appSettings)
        .insert(
          const db.AppSettingsCompanion(
            id: drift.Value<int>(0),
            themeId: drift.Value<String>('midnight'),
          ),
        );
    expect(insertedId, 0);

    await repository.savePreferences(
      const PlannerPreferences(
        focusDuration: Duration(minutes: 50),
        strictMode: true,
        countUp: true,
        whiteNoiseSoundId: 'rain',
        dailyGoalMinutes: 180,
      ),
    );

    final rawRow = (await database.select(database.appSettings).get()).single;
    expect(rawRow.workDurationSec, 3000);

    final preferences = await repository.watchPreferences().first;
    expect(preferences.focusDuration, const Duration(minutes: 50));
    expect(preferences.strictMode, isTrue);
    expect(preferences.countUp, isTrue);
    expect(preferences.whiteNoiseSoundId, 'rain');
    expect(preferences.dailyGoalMinutes, 180);

    final row = (await database.select(database.appSettings).get()).single;
    expect(row.themeId, 'midnight');
  });
}
