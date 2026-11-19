import 'package:equatable/equatable.dart';

/// Base contract for every use case.
///
/// [T] is the returned value and [Params] the input of the use case.
abstract class UseCase<T, Params> {
  const UseCase();

  Future<T> call(Params params);
}

/// Params placeholder for use cases that take no input.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
