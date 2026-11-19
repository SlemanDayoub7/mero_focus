import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/constants/defaults.dart';
import 'package:mero_focus/core/database/app_database.dart';

void main() {
  test('database exposes the six documented tables', () {
    final database = AppDatabase.forTesting();
    addTearDown(database.close);

    expect(database.allTables, hasLength(6));
  });

  test('AppSettings row uses the documented default values', () async {
    final database = AppDatabase.forTesting();
    addTearDown(database.close);

    await database
        .into(database.appSettings)
        .insert(AppSettingsCompanion.insert());
    final settings = (await database.select(database.appSettings).get()).single;

    expect(settings.workDurationSec, AppDefaults.workDurationSec);
    expect(settings.shortBreakSec, AppDefaults.shortBreakSec);
    expect(settings.longBreakSec, AppDefaults.longBreakSec);
    expect(
      settings.roundsBeforeLongBreak,
      AppDefaults.roundsBeforeLongBreak,
    );
    expect(settings.themeId, AppDefaults.themeId);
    expect(settings.backgroundId, AppDefaults.backgroundId);
    expect(settings.timerEndSoundId, AppDefaults.timerEndSoundId);
  });
}
