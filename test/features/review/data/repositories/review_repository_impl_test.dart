import 'package:flutter_test/flutter_test.dart';
import 'package:mero_focus/features/review/data/datasources/review_local_datasource.dart';
import 'package:mero_focus/features/review/data/repositories/review_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewLocalDataSource extends Mock
    implements ReviewLocalDataSource {}

void main() {
  late MockReviewLocalDataSource localDataSource;
  late ReviewRepositoryImpl repository;

  setUp(() {
    localDataSource = MockReviewLocalDataSource();
    repository = ReviewRepositoryImpl(localDataSource);
  });

  group('ReviewRepositoryImpl', () {
    test('getDueEntries returns only the entries that are due', () async {
      // TODO: arrange, act and assert.
    });
  });
}
