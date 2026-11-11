import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/review/domain/entities/review_entry.dart';
import 'package:mero_focus/features/review/domain/repositories/review_repository.dart';

/// Adds a new entry to the review queue.
class AddEntry extends UseCase<void, ReviewEntry> {
  const AddEntry(this._repository);

  final ReviewRepository _repository;

  @override
  Future<void> call(ReviewEntry params) {
    // TODO: delegate to ReviewRepository.addEntry.
    throw UnimplementedError();
  }
}
