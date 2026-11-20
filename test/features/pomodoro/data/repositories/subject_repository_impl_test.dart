import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;
import 'package:mero_focus/features/pomodoro/data/repositories/subject_repository_impl.dart';
import 'package:mero_focus/features/pomodoro/domain/entities/subject.dart';

void main() {
  test('subjects are persisted and removal clears references', () async {
    final database = db.AppDatabase.forTesting();
    addTearDown(database.close);
    final repository = SubjectRepositoryImpl(database);

    final subjectId = await repository.addSubject(
      const Subject(name: 'Math', colorHex: 'FF42A5F5'),
    );
    await database
        .into(database.tasks)
        .insert(
          db.TasksCompanion.insert(
            title: 'Read chapter 1',
            subjectId: drift.Value(subjectId),
          ),
        );
    await database
        .into(database.focusSessions)
        .insert(
          db.FocusSessionsCompanion.insert(
            startTime: DateTime(2026, 3, 1, 10),
            plannedDurationSeconds: 1500,
            actualDurationSeconds: 1500,
            sessionType: 0,
            tagId: drift.Value(subjectId),
          ),
        );

    final subjects = await repository.watchSubjects().first;
    expect(subjects, hasLength(1));
    expect(subjects.single.id, subjectId);
    expect(subjects.single.name, 'Math');
    expect(subjects.single.colorHex, 'FF42A5F5');

    await repository.removeSubject(subjectId);

    expect(await repository.watchSubjects().first, isEmpty);
    final task = (await database.select(database.tasks).get()).single;
    expect(task.subjectId, isNull);
    final session =
        (await database.select(database.focusSessions).get()).single;
    expect(session.tagId, isNull);
  });
}
