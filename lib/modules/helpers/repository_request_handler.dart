import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/result/result_custom.dart';

class RepositoryRequestHandler {
  Future<ResultCustom<Failure, T>> execute<T, R>({
    required Future<R> Function() request,
    required T Function(R response) mapper,
    String successMessage = '',
    String Function(R response)? errorMapper,
  }) async {
    try {
      final response = await request();

      final errorMessage = errorMapper?.call(response);

      if (errorMessage != null && errorMessage.isNotEmpty) {
        return ErrorResult(message: errorMessage);
      }

      return Success(mapper(response), successMessage);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
