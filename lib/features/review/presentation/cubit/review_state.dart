import 'package:equatable/equatable.dart';

/// Base state of the review feature.
sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

/// Initial state, before anything is loaded.
final class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

// TODO: add ReviewLoading, ReviewLoaded (with the due entries) and ReviewError.
