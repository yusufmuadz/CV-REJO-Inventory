class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ServerException({required this.message, this.statusCode, this.error});

  @override
  String toString() => "ServerException: $message ($statusCode)";
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => "CacheException: $message";
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => "NetworkException: $message";
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);
}

class UnknownException implements Exception {
  final String message;

  UnknownException(this.message);
}
