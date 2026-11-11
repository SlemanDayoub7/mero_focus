import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/review/domain/entities/review_entry.dart';
import 'package:mero_focus/features/review/domain/repositories/review_repository.dart';

/// Returns every entry that is due for review now.
class GetDueEntries extends UseCase<List<ReviewEntry>, NoParams> {
  const GetDueEntries(this._repository);

  final ReviewRepository _repository;

  @override
  Future<List<ReviewEntry>> call(NoParams params) {
    // TODO: delegate to ReviewRepository.getDueEntries.
    throw UnimplementedError();
  }
}
