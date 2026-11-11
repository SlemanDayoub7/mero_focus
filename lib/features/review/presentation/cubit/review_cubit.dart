import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mero_focus/features/review/domain/usecases/add_entry.dart';
import 'package:mero_focus/features/review/domain/usecases/get_due_entries.dart';
import 'package:mero_focus/features/review/domain/usecases/update_entry.dart';
import 'package:mero_focus/features/review/presentation/cubit/review_state.dart';

/// Drives the daily review screen.
class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit({
    required AddEntry addEntry,
    required GetDueEntries getDueEntries,
    required UpdateEntry updateEntry,
  }) : _addEntry = addEntry,
       _getDueEntries = getDueEntries,
       _updateEntry = updateEntry,
       super(const ReviewInitial());

  final AddEntry _addEntry;
  final GetDueEntries _getDueEntries;
  final UpdateEntry _updateEntry;

  // TODO: load the entries that are due today.
  Future<void> loadDueEntries() => throw UnimplementedError();

  // TODO: add a new entry and refresh the queue.
  Future<void> addEntry() => throw UnimplementedError();

  // TODO: submit the result of a review and refresh the queue.
  Future<void> submitReview() => throw UnimplementedError();
}
