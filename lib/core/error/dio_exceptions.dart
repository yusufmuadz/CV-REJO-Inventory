import 'package:dio/dio.dart';

import 'exceptions.dart';

class HandleDioExceptions {
  ServerException handleDioError(DioException error) {
    String message = 'An error occurred';
    int? statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet.';
        break;
      case DioExceptionType.badResponse:
        switch (statusCode) {
          case 400:
            message = error.response?.data['message'] ?? 'Bad request';
            break;
          case 401:
            message = 'Unauthorized. Please login again.';
            break;
          case 403:
            message = 'Forbidden. You don\'t have permission.';
            break;
          case 404:
            message = 'Resource not found.';
            break;
          case 409:
            message = error.response?.data['message'] ?? 'Conflict occurred';
            break;
          case 422:
            message = error.response?.data['message'] ?? 'Validation failed';
            break;
          case 500:
            message = 'Internal server error. Please try again later.';
            break;
          case 502:
          case 503:
            message = 'Service temporarily unavailable. Please try again.';
            break;
          default:
            message =
                error.response?.data['message'] ??
                'Error occurred (Status: $statusCode)';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error. Please check your internet.';
        break;
      case DioExceptionType.badCertificate:
        message = 'Bad certificate. Security issue detected.';
        break;
      case DioExceptionType.unknown:
      default:
        message = 'Unknown error occurred';
    }

    return ServerException(
      message: message,
      statusCode: statusCode ?? 500,
      error: error,
    );
  }
}
