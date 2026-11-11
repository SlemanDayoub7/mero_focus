import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/review/domain/repositories/review_repository.dart';
import 'package:mero_focus/features/review/domain/usecases/add_entry.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late MockReviewRepository repository;
  late AddEntry useCase;

  setUp(() {
    repository = MockReviewRepository();
    useCase = AddEntry(repository);
  });

  group('AddEntry', () {
    test('forwards the entry to the repository', () async {
      // TODO: arrange, act and assert.
    });
  });
}
