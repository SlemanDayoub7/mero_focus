import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mero_focus/features/capture/domain/usecases/delete_capture.dart';
import 'package:mero_focus/features/capture/domain/usecases/get_captures.dart';
import 'package:mero_focus/features/capture/domain/usecases/save_capture.dart';
import 'package:mero_focus/features/capture/presentation/cubit/capture_state.dart';

/// Drives the capture screen.
class CaptureCubit extends Cubit<CaptureState> {
  CaptureCubit({
    required GetCaptures getCaptures,
    required SaveCapture saveCapture,
    required DeleteCapture deleteCapture,
  }) : _getCaptures = getCaptures,
       _saveCapture = saveCapture,
       _deleteCapture = deleteCapture,
       super(const CaptureInitial());

  final GetCaptures _getCaptures;
  final SaveCapture _saveCapture;
  final DeleteCapture _deleteCapture;

  // TODO: load the stored captures.
  Future<void> loadCaptures() => throw UnimplementedError();

  // TODO: capture a new image, text or drawing.
  Future<void> addCapture() => throw UnimplementedError();

  // TODO: delete a capture by id.
  Future<void> removeCapture(String id) => throw UnimplementedError();
}
