import 'package:hive/hive.dart';

import 'package:mero_focus/features/review/data/models/review_entry_model.dart';

/// Local (Hive) data source for review entries.
class ReviewLocalDataSource {
  const ReviewLocalDataSource(this._box);

  final Box<ReviewEntryModel> _box;

  // TODO: read every stored entry.
  Future<List<ReviewEntryModel>> getEntries() => throw UnimplementedError();

  // TODO: insert or replace one entry.
  Future<void> putEntry(ReviewEntryModel model) => throw UnimplementedError();

  // TODO: remove one entry by id.
  Future<void> deleteEntry(String id) => throw UnimplementedError();
}
