import 'package:hive/hive.dart';

import 'package:mero_focus/features/capture/data/models/capture_entry_model.dart';

/// Local (Hive) data source for captures.
class CaptureLocalDataSource {
  const CaptureLocalDataSource(this._box);

  final Box<CaptureEntryModel> _box;

  // TODO: read every stored capture.
  Future<List<CaptureEntryModel>> getCaptures() => throw UnimplementedError();

  // TODO: insert or replace one capture.
  Future<void> putCapture(CaptureEntryModel model) => throw UnimplementedError();

  // TODO: remove one capture by id.
  Future<void> deleteCapture(String id) => throw UnimplementedError();
}
