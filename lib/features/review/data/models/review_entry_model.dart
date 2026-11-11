import 'package:hive/hive.dart';

import 'package:mero_focus/features/review/domain/entities/review_entry.dart';

// NOTE: hive_generator is intentionally not used in this project.
// The Hive adapter for this model must be written and registered manually
// (see core/di/injection_container.dart).
// TODO: add `toEntity()` / `fromEntity()` mapping.

/// Hive-persisted representation of a [ReviewEntry].
@HiveType(typeId: 0)
class ReviewEntryModel {
  const ReviewEntryModel({
    required this.id,
    required this.createdAt,
    required this.dueAt,
    required this.intervalDays,
    required this.easeFactor,
    required this.repetitions,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final DateTime dueAt;

  @HiveField(3)
  final int intervalDays;

  @HiveField(4)
  final double easeFactor;

  @HiveField(5)
  final int repetitions;
}
