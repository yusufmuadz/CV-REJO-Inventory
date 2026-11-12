import '../../core/error/failures.dart';
import '../../core/result/result_custom.dart';

class RepositoryRequestHandler {
  Future<ResultCustom<Failure, T>> execute<T, R>({
    required Future<R> Function() request,
    required T Function(R response) mapper,
    String successMessage = '',
  }) async {
    try {
      final response = await request();

      return Success(mapper(response), successMessage);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
