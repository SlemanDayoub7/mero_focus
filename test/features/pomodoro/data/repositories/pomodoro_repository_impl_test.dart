import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;
import 'package:mero_focus/features/pomodoro/data/repositories/pomodoro_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/focus_session.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/session_type.dart';

void main() {
  test('PomodoroRepositoryImpl saves and reads raw focus sessions', () async {
    final database = db.AppDatabase.forTesting();
    addTearDown(database.close);
    final repository = PomodoroRepositoryImpl(database);

    final now = DateTime(2026, 3, 1, 10);
    final session = FocusSession(
      startTime: now.subtract(SessionType.longBreak.duration),
      endTime: now,
      plannedDuration: SessionType.longBreak.duration,
      actualDuration: SessionType.longBreak.duration,
      sessionType: SessionType.longBreak,
    );

    final id = await repository.saveSession(session);
    expect(id, greaterThan(0));

    final sessions = await repository.getSessions();
    expect(sessions, hasLength(1));
    final stored = sessions.single;
    expect(stored.id, id);
    expect(stored.startTime, session.startTime);
    expect(stored.endTime, session.endTime);
    expect(stored.plannedDuration, session.plannedDuration);
    expect(stored.actualDuration, session.actualDuration);
    expect(stored.sessionType, SessionType.longBreak);
    expect(stored.completed, isTrue);
    expect(stored.completionPercentage, 100);
  });

  test('PomodoroRepositoryImpl returns newest sessions first', () async {
    final database = db.AppDatabase.forTesting();
    addTearDown(database.close);
    final repository = PomodoroRepositoryImpl(database);

    final base = DateTime(2026, 3, 1, 10);
    for (var index = 0; index < 3; index++) {
      await repository.saveSession(
        FocusSession(
          startTime: base.add(Duration(hours: index)),
          endTime: base.add(Duration(hours: index, minutes: 5)),
          plannedDuration: SessionType.work.duration,
          actualDuration: SessionType.work.duration,
          sessionType: SessionType.work,
        ),
      );
    }

    final sessions = await repository.getSessions();
    expect(sessions.map((session) => session.startTime), [
      base.add(const Duration(hours: 2)),
      base.add(const Duration(hours: 1)),
      base,
    ]);
  });
}
