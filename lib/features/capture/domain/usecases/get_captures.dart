import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/capture/domain/entities/capture_entry.dart';
import 'package:mero_focus/features/capture/domain/repositories/capture_repository.dart';

/// Returns every stored capture.
class GetCaptures extends UseCase<List<CaptureEntry>, NoParams> {
  const GetCaptures(this._repository);

  final CaptureRepository _repository;

  @override
  Future<List<CaptureEntry>> call(NoParams params) {
    // TODO: delegate to CaptureRepository.getCaptures.
    throw UnimplementedError();
  }
}
