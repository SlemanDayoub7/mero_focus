import 'package:equatable/equatable.dart';

/// A single item tracked by the spaced-repetition engine.
class ReviewEntry extends Equatable {
  const ReviewEntry({
    required this.id,
    required this.createdAt,
    required this.dueAt,
    this.intervalDays = 0,
    this.easeFactor = 2.5,
    this.repetitions = 0,
  });

  final String id;
  final DateTime createdAt;
  final DateTime dueAt;
  final int intervalDays;
  final double easeFactor;
  final int repetitions;

  // TODO: return a copy with the given fields replaced.
  ReviewEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? dueAt,
    int? intervalDays,
    double? easeFactor,
    int? repetitions,
  }) =>
      throw UnimplementedError();

  @override
  List<Object?> get props => [
    id,
    createdAt,
    dueAt,
    intervalDays,
    easeFactor,
    repetitions,
  ];
}
