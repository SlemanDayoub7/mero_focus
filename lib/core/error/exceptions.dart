/// Base class for every exception thrown by the data layer.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => 'AppException: $message';
}

// TODO: add the concrete exceptions (cache, notification, permission, ...).
