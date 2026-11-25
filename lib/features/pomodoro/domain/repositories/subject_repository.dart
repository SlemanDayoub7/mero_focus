import '../entities/subject.dart';

/// Persistence port for study subjects (ADR-0005).
abstract class SubjectRepository {
  Stream<List<Subject>> watchSubjects();

  Future<int> addSubject(Subject subject);

  Future<void> updateSubject(Subject subject);

  Future<void> removeSubject(int id);
}
