abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// No internet connection at all.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection"]);
}

/// The server responded with an error (4xx / 5xx) or was down/suspended.
class ServerFailure extends Failure {
  const ServerFailure([super.message = "A server error occurred"]);
}

/// Error reading/writing local storage (Hive).
class CacheFailure extends Failure {
  const CacheFailure([super.message = "A local storage error occurred"]);
}

/// Any other unexpected error.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = "An unexpected error occurred"]);
}

/// Result of an operation that can either succeed (Success) or fail
/// (Error) - instead of throwing Exceptions and catching them loosely
/// everywhere.
abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);
}
