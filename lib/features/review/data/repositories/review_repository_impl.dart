import 'package:mero_focus/features/review/data/datasources/review_local_datasource.dart';
import 'package:mero_focus/features/review/domain/entities/review_entry.dart';
import 'package:mero_focus/features/review/domain/repositories/review_repository.dart';

/// Hive-backed implementation of [ReviewRepository].
class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl(this._localDataSource);

  final ReviewLocalDataSource _localDataSource;

  @override
  Future<void> addEntry(ReviewEntry entry) {
    // TODO: map the entity to ReviewEntryModel and persist it.
    throw UnimplementedError();
  }

  @override
  Future<List<ReviewEntry>> getDueEntries() {
    // TODO: read from Hive and keep the entries whose dueAt is in the past.
    throw UnimplementedError();
  }

  @override
  Future<void> updateEntry(ReviewEntry entry) {
    // TODO: map the entity to ReviewEntryModel and persist it.
    throw UnimplementedError();
  }
}
