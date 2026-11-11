import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/review/domain/usecases/add_entry.dart';
import 'package:mero_focus/features/review/domain/usecases/get_due_entries.dart';
import 'package:mero_focus/features/review/domain/usecases/update_entry.dart';
import 'package:mero_focus/features/review/presentation/cubit/review_cubit.dart';
import 'package:mero_focus/features/review/presentation/cubit/review_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAddEntry extends Mock implements AddEntry {}

class MockGetDueEntries extends Mock implements GetDueEntries {}

class MockUpdateEntry extends Mock implements UpdateEntry {}

void main() {
  late AddEntry addEntry;
  late GetDueEntries getDueEntries;
  late UpdateEntry updateEntry;

  setUp(() {
    addEntry = MockAddEntry();
    getDueEntries = MockGetDueEntries();
    updateEntry = MockUpdateEntry();
  });

  blocTest<ReviewCubit, ReviewState>(
    'emits the due entries when loadDueEntries succeeds',
    build: () => ReviewCubit(
      addEntry: addEntry,
      getDueEntries: getDueEntries,
      updateEntry: updateEntry,
    ),
    // TODO: add the expected states and verify the interactions.
  );
}
