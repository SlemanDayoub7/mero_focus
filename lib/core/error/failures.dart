import 'package:equatable/equatable.dart';

/// Base class for every failure returned to the presentation layer.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// TODO: add the concrete failures (cache, notification, permission, ...).
