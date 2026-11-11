import 'package:equatable/equatable.dart';

/// The kind of media stored by a capture.
enum CaptureKind { image, text, drawing }

/// One captured note, image or drawing.
class CaptureEntry extends Equatable {
  const CaptureEntry({
    required this.id,
    required this.kind,
    required this.createdAt,
    this.text,
    this.filePath,
  });

  final String id;
  final CaptureKind kind;
  final DateTime createdAt;
  final String? text;
  final String? filePath;

  @override
  List<Object?> get props => [id, kind, createdAt, text, filePath];
}
