
abstract class Failure {
  final String message;

  const Failure(this.message);
}

// General
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Auth Example
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure(super.message);
}

class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure(super.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure(super.message);
}

class InvalidPasswordFailure extends Failure {
  const InvalidPasswordFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
