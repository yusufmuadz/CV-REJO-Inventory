import 'dart:async';
import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import '../services/storage_service.dart';
import 'api_endpoints.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage;

  DioInterceptor({required this.dio, required this.tokenStorage});

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshCompleters = [];

  /// =======================
  /// REQUEST
  /// =======================
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    return handler.next(options);
  }

  /// =======================
  /// ERROR (401 HANDLER)
  /// =======================
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode != 401 && err.requestOptions.extra["isRetry"] == true) {
      /// ======================
      /// MAP ERROR → EXCEPTION
      /// ======================
      // return handler.reject(_mapDioError(err));
      return handler.next(err);
    }

    /// ======================
    /// HANDLE 401 (REFRESH TOKEN)
    /// ======================
    try {
      // Kalau lagi refresh → tunggu
      if (_isRefreshing) {
        final completer = Completer<void>();
        _refreshCompleters.add(completer);

        await completer.future;

        final newToken = await tokenStorage.getAccessToken();

        final requestOptions = err.requestOptions;
        requestOptions.headers["Authorization"] = "Bearer $newToken";
        requestOptions.extra["isRetry"] = true;

        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      }

      // Mulai refresh
      _isRefreshing = true;

      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        return _handleLogout(handler, err);
      }

      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {"refresh_token": refreshToken},
        options: Options(
          headers: {
            "Authorization": null, // penting! jangan kirim token lama
          },
        ),
      );

      final newAccessToken = response.data["access_token"];
      final newRefreshToken = response.data["refresh_token"];

      await tokenStorage.saveToken(accessToken: newAccessToken, refreshToken: newRefreshToken);

      // Selesaikan semua request yang nunggu
      for (final completer in _refreshCompleters) {
        completer.complete();
      }
      _refreshCompleters.clear();

      _isRefreshing = false;

      // Retry request yang gagal
      final requestOptions = err.requestOptions;
      requestOptions.headers["Authorization"] = "Bearer $newAccessToken";
      requestOptions.extra["isRetry"] = true;

      final retryResponse = await dio.fetch(requestOptions);
      return handler.resolve(retryResponse);
    } catch (e) {
      _isRefreshing = false;

      for (final completer in _refreshCompleters) {
        completer.completeError(e);
      }
      _refreshCompleters.clear();

      await tokenStorage.clear();

      // return handler.reject(
      //     DioException(
      //       requestOptions: err.requestOptions,
      //       error: UnauthorizedException("Session expired"),
      //     ),
      //   );

      return _handleLogout(handler, err);
    }
  }

  /// =======================
  /// LOGOUT HANDLER
  /// =======================
  void _handleLogout(ErrorInterceptorHandler handler, DioException err) {
    // throw UnauthorizedException("Session expired");
    // Bisa trigger logout di sini (Get.offAllNamed('/login'))
    return handler.next(err);
  }
}

DioException _mapDioError(DioException err) {
  if (err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.receiveTimeout) {
    return DioException(
      requestOptions: err.requestOptions,
      error: TimeoutException("Request timeout"),
    );
  }

  if (err.type == DioExceptionType.connectionError) {
    return DioException(
      requestOptions: err.requestOptions,
      error: NetworkException(message: "No internet connection"),
    );
  }

  final statusCode = err.response?.statusCode;

  if (statusCode == 401) {
    return DioException(
      requestOptions: err.requestOptions,
      error: UnauthorizedException("Unauthorized"),
    );
  }

  return DioException(
    requestOptions: err.requestOptions,
    error: ServerException(
      message: err.response?.data?["message"] ?? "Server error",
      statusCode: statusCode,
    ),
  );
}
