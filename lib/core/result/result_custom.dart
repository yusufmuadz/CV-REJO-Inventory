sealed class ResultCustom<Failure, T> {
  const ResultCustom();
}

class Success<Failure, T> extends ResultCustom<Failure, T> {
  final T data;
  final String? failure;
  const Success(this.data, this.failure);
}

class ErrorResult<Failure, T> extends ResultCustom<Failure, T> {
  final String message;
  final int? statusCode;
  final bool? isMaxFailure;
  const ErrorResult({required this.message, this.statusCode, this.isMaxFailure});
}
