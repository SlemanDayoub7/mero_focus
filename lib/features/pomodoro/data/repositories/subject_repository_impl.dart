import 'package:drift/drift.dart';
import 'package:mero_focus/core/database/app_database.dart' as db;

import '../../domain/entities/subject.dart';
import '../../domain/repositories/subject_repository.dart';

/// Drift-backed implementation of the study-subject port.
class SubjectRepositoryImpl implements SubjectRepository {
  const SubjectRepositoryImpl(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Subject>> watchSubjects() {
    final query = _database.select(_database.tags)
      ..orderBy([(row) => OrderingTerm.asc(row.name)]);
    return query.watch().map(
      (rows) => rows.map(_toEntity).toList(growable: false),
    );
  }

  @override
  Future<int> addSubject(Subject subject) {
    return _database
        .into(_database.tags)
        .insert(
          db.TagsCompanion.insert(
            name: subject.name,
            colorHex: subject.colorHex,
          ),
        );
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    final id = subject.id;
    if (id == null) return;
    await (_database.update(_database.tags)
          ..where((row) => row.id.equals(id)))
        .write(
      db.TagsCompanion(
        name: Value(subject.name),
        colorHex: Value(subject.colorHex),
      ),
    );
  }

  @override
  Future<void> removeSubject(int id) async {
    await _database.transaction(() async {
      await (_database.update(_database.tasks)
            ..where((row) => row.subjectId.equals(id)))
          .write(const db.TasksCompanion(subjectId: Value<int?>(null)));
      await (_database.update(_database.focusSessions)
            ..where((row) => row.tagId.equals(id)))
          .write(const db.FocusSessionsCompanion(tagId: Value<int?>(null)));
      await (_database.delete(
        _database.tags,
      )..where((row) => row.id.equals(id))).go();
    });
  }

  Subject _toEntity(db.Tag row) =>
      Subject(id: row.id, name: row.name, colorHex: row.colorHex);
}
