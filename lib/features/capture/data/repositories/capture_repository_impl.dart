import 'package:mero_focus/features/capture/data/datasources/capture_local_datasource.dart';
import 'package:mero_focus/features/capture/domain/entities/capture_entry.dart';
import 'package:mero_focus/features/capture/domain/repositories/capture_repository.dart';

/// Hive-backed implementation of [CaptureRepository].
class CaptureRepositoryImpl implements CaptureRepository {
  const CaptureRepositoryImpl(this._localDataSource);

  final CaptureLocalDataSource _localDataSource;

  @override
  Future<void> saveCapture(CaptureEntry entry) {
    // TODO: map the entity to CaptureEntryModel and persist it.
    throw UnimplementedError();
  }

  @override
  Future<List<CaptureEntry>> getCaptures() {
    // TODO: read from Hive and map the models back to entities.
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCapture(String id) {
    // TODO: delete the capture and its file, if any.
    throw UnimplementedError();
  }
}
