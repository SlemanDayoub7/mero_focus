import 'package:mero_focus/core/usecases/usecase.dart';
import 'package:mero_focus/features/capture/domain/repositories/capture_repository.dart';

/// Deletes one capture by id.
class DeleteCapture extends UseCase<void, String> {
  const DeleteCapture(this._repository);

  final CaptureRepository _repository;

  @override
  Future<void> call(String params) {
    // TODO: delegate to CaptureRepository.deleteCapture.
    throw UnimplementedError();
  }
}
