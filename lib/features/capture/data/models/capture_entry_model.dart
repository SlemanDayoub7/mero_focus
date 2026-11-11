import 'package:hive/hive.dart';

// NOTE: hive_generator is intentionally not used in this project.
// The Hive adapter for this model must be written and registered manually.
// TODO: add `toEntity()` / `fromEntity()` mapping, including CaptureKind.

/// Hive-persisted representation of a capture.
@HiveType(typeId: 1)
class CaptureEntryModel {
  const CaptureEntryModel({
    required this.id,
    required this.kindIndex,
    required this.createdAt,
    this.text,
    this.filePath,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int kindIndex;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final String? text;

  @HiveField(4)
  final String? filePath;
}
