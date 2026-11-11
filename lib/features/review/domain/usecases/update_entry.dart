import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/review/domain/entities/review_entry.dart';
import 'package:mero_focus/features/review/domain/repositories/review_repository.dart';

/// Persists the result of a review (new interval, due date, ...).
class UpdateEntry extends UseCase<void, ReviewEntry> {
  const UpdateEntry(this._repository);

  final ReviewRepository _repository;

  @override
  Future<void> call(ReviewEntry params) {
    // TODO: delegate to ReviewRepository.updateEntry.
    throw UnimplementedError();
  }
}
