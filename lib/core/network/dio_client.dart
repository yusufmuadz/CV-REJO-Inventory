import 'dart:convert';

import 'package:dio/dio.dart';
import '../services/storage_service.dart';
import 'base_response.dart';
import 'dio_interceptor.dart';
import 'api_endpoints.dart';

class DioClient {
  late Dio dio;

  DioClient(TokenStorage tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    // Penting: jangan retry infinite loop
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(DioInterceptor(dio: dio, tokenStorage: tokenStorage));

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  // ================= PARSING RESPONSE =================

  Future<BaseResponseSuccess<T>> parseResponse<T>(
    String body,
    T Function(Object? json) fromJsonT,
  ) async {
    final decoded = jsonDecode(body);
    return BaseResponseSuccess<T>.fromJson(decoded, fromJsonT);
  }

  // Generic GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  // Generic POST
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          method: "POST",
          validateStatus: (status) => status != null && status < 500,
        ),
      );
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  // PUT
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  // DELETE
  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
