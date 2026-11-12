import 'package:dio/dio.dart';

import '../../core/error/dio_exceptions.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/dio_client.dart';

class ApiRequestHandler {
  final DioClient dioClient;

  ApiRequestHandler(this.dioClient);

  Future<T> execute<T>({
    required Future<Response<dynamic>> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();

      final statusCode = response.statusCode;
      final data = response.data;

      const successStatusCodes = {200, 201};

      if (data == null) {
        throw ServerException(
          message: 'Response data is empty',
          statusCode: statusCode ?? 500,
        );
      }

      if (!successStatusCodes.contains(statusCode)) {
        throw ServerException(
          message: data is Map
              ? data['message']?.toString() ?? 'Request failed'
              : 'Request failed',
          statusCode: statusCode ?? 500,
        );
      }

      return parser(data);
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }
}
