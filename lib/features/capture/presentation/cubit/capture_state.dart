import 'package:equatable/equatable.dart';

/// Base state of the capture feature.
sealed class CaptureState extends Equatable {
  const CaptureState();

  @override
  List<Object?> get props => [];
}

/// Initial state, before anything is loaded.
final class CaptureInitial extends CaptureState {
  const CaptureInitial();
}

// TODO: add CaptureLoading, CaptureLoaded (with the captures) and CaptureError.
