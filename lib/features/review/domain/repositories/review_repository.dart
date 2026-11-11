import 'package:mero_focus/features/review/domain/entities/review_entry.dart';

/// Contract for the review (SRS) data operations.
abstract interface class ReviewRepository {
  // TODO: return the entries that are due now.
  Future<List<ReviewEntry>> getDueEntries();

  // TODO: persist a new entry.
  Future<void> addEntry(ReviewEntry entry);

  // TODO: persist the changes of an existing entry.
  Future<void> updateEntry(ReviewEntry entry);
}
