import 'package:mero_focus/features/capture/domain/entities/capture_entry.dart';

/// Contract for the capture data operations.
abstract interface class CaptureRepository {
  // TODO: return every stored capture, newest first.
  Future<List<CaptureEntry>> getCaptures();

  // TODO: persist a new capture.
  Future<void> saveCapture(CaptureEntry entry);

  // TODO: delete a capture by id.
  Future<void> deleteCapture(String id);
}
