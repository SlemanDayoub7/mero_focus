import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/capture/domain/entities/capture_entry.dart';
import 'package:mero_focus/features/capture/domain/repositories/capture_repository.dart';

/// Persists a new capture (image, text or drawing).
class SaveCapture extends UseCase<void, CaptureEntry> {
  const SaveCapture(this._repository);

  final CaptureRepository _repository;

  @override
  Future<void> call(CaptureEntry params) {
    // TODO: delegate to CaptureRepository.saveCapture.
    throw UnimplementedError();
  }
}
