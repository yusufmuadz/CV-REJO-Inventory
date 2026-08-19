import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData;
import '../services/storage_service.dart';
import 'base_response.dart';
// import 'connectivity_network.dart';
import 'dio_interceptor.dart';
import 'api_endpoints.dart';
import 'koneksi_check.dart';

class DioClient {
  late Dio dio;
  final KoneksiCheck _network = Get.find<KoneksiCheck>();

  DioClient(TokenStorage tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
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
          // Cek koneksi sebelum request
          if (_network.statusStream.value == ConnectionStatus.offline) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode != null && response.statusCode! >= 400) {
            _handleApiError(response);
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          final message = _parseDioError(e);

          // // Tampilkan snackbar error global (opsional, bisa dimatikan)
          // if (e.type != DioExceptionType.badResponse) {
          //   Get.snackbar(
          //     'Error',
          //     message,
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red.shade400,
          //     colorText: Colors.white,
          //     duration: const Duration(seconds: 4),
          //     icon: const Icon(Icons.error_outline, color: Colors.white),
          //   );
          // }

          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: message,
              type: e.type,
              response: e.response,
            ),
          );
        },
      ),
    );

    dio.interceptors.add(DioInterceptor(dio: dio, tokenStorage: tokenStorage));

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint('🔍 DIO LOG: $obj'),
      ),
    );
  }

  // ================= ERROR PARSING =================

  String _parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '⏱️ Request timeout. Periksa koneksi Anda.';

      case DioExceptionType.connectionError:
        return '🔌 Tidak dapat terhubung ke server.';

      case DioExceptionType.badCertificate:
        return '🔒 Sertifikat keamanan tidak valid.';

      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return '🔑 Sesi expired, silakan login ulang.';
        if (code == 403) return '⛔ Akses ditolak.';
        if (code == 404) return '📍 Data tidak ditemukan.';
        if (code != null && code >= 500) {
          return '🖥️ Server error, coba beberapa saat lagi.';
        }
        return '❌ Error: ${e.response?.data['message'] ?? 'Unknown error'}';

      case DioExceptionType.cancel:
        return '🚫 Request dibatalkan.';

      case DioExceptionType.unknown:
      default:
        // Cek apakah error dari network controller
        if (e.error.toString().contains('No internet')) {
          return '📶 Periksa koneksi internet Anda.';
        }
        return '⚠️ Terjadi kesalahan: ${e.message ?? 'Unknown'}';
    }
  }

  void _handleApiError(Response response) {
    // Optional: Handle error spesifik dari backend
    final data = response.data;
    if (data is Map && data['message'] != null) {
      // Bisa log atau trigger event lain
      debugPrint('⚠️ API Error: ${data['message']}');
    }
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
  Future<Response> post(
    String path, {
    dynamic data,
    String? contentType,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          contentType: contentType ?? Headers.jsonContentType,
          method: "POST",
          validateStatus: (status) => status != null && status < 500,
        ),
      );
    } on DioException catch (e) {
      debugPrint('========== DIO ERROR ==========');
      debugPrint('TYPE       : ${e.type}');
      debugPrint('MESSAGE    : ${e.message}');
      debugPrint('ERROR      : ${e.error}');
      debugPrint('STATUS     : ${e.response?.statusCode}');
      debugPrint('RESPONSE   : ${e.response?.data}');
      debugPrint('URL        : ${e.requestOptions.uri}');
      debugPrint('METHOD     : ${e.requestOptions.method}');
      debugPrint('HEADERS    : ${e.requestOptions.headers}');
      debugPrint('CONTENT    : ${e.requestOptions.contentType}');
      debugPrint('================================');

      throw e.error ?? e; // rethrow;
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

  /// ================= TEST DIO =================
  ///
  /// Digunakan untuk debugging request tanpa interceptor.
  /// Berguna untuk membandingkan perilaku Dio murni
  /// dengan DioClient yang menggunakan interceptor.
  Future<Response> testPost(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.plain,
  }) async {
    final testDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: responseType,
      ),
    );

    try {
      debugPrint('========== TEST DIO REQUEST ==========');
      debugPrint('URL: ${testDio.options.baseUrl}$path');

      if (data is FormData) {
        debugPrint('----- FORM FIELDS -----');

        for (final field in data.fields) {
          debugPrint('FIELD ${field.key} = ${field.value}');
        }

        debugPrint('----- FORM FILES -----');

        for (final file in data.files) {
          debugPrint('FILE ${file.key} = ${file.value.filename}');
        }
      } else {
        debugPrint('DATA: $data');
      }

      debugPrint('HEADERS: $headers');
      debugPrint('======================================');

      final response = await testDio.post(
        path,
        data: data,
        options: Options(headers: headers, responseType: responseType),
      );

      debugPrint('========== TEST DIO RESPONSE ==========');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('CONTENT TYPE: ${response.headers['content-type']}');
      debugPrint('DATA: ${response.data}');
      debugPrint('=======================================');

      return response;
    } on DioException catch (e) {
      debugPrint('========== TEST DIO ERROR =============');
      debugPrint('TYPE: ${e.type}');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('ERROR: ${e.error}');
      debugPrint('STATUS: ${e.response?.statusCode}');
      debugPrint('RESPONSE: ${e.response?.data}');
      debugPrint('URI: ${e.requestOptions.uri}');
      debugPrint('METHOD: ${e.requestOptions.method}');
      debugPrint('HEADERS: ${e.requestOptions.headers}');
      debugPrint('CONTENT TYPE: ${e.requestOptions.contentType}');
      debugPrint('=======================================');

      rethrow;
    } catch (e, stackTrace) {
      debugPrint('========== TEST DIO UNKNOWN ===========');
      debugPrint('ERROR: $e');
      debugPrint('TYPE: ${e.runtimeType}');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('=======================================');

      rethrow;
    }
  }
}
