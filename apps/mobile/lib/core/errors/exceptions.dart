/// Domain and infrastructure exceptions.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException($message)';
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.cause});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause});
}

final class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause});
}
