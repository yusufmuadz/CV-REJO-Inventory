import '../error/exceptions.dart';
import '../error/failures.dart';

Failure mapExceptionToFailure(Exception e) {
  if (e is ServerException) {
    if (e.statusCode == 401) {
      return UnauthorizedFailure(e.message);
    }
    return ServerFailure(e.message);
  } else if (e is UnauthorizedException) {
    return UnauthorizedFailure(e.message);
  } else if (e is CacheException) {
    return CacheFailure(e.message);
  } else if (e is NetworkException) {
    return NetworkFailure(e.message);
  } else if (e is TimeoutException) {
    return TimeoutFailure(e.message);
  } else {
    return UnknownFailure(e.toString());
  }
}