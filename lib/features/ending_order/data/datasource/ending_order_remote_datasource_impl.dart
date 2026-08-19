import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../detail_order/data/models/response_model_basic.dart';
import '../../../rit_information/domain/params/trouble_rit_param.dart';
import '../../../rit_information/presentation/controllers/enums/enum_trouble.dart';
import '../../domain/params/post_ending_order_param.dart';
import 'ending_order_remote_datasource.dart';

class EndingOrderRemoteDataSourceImpl implements EndingOrderRemoteDataSource {
  final DioClient dioClient;

  EndingOrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelBasic> postEndingOrder(ParamsEndingOrder params) async {
    try {
      String nameFile = 'file';

      debugPrint(params.invoice);

      // if (params.role == 'deliver') {
      //   nameFile = 'foto';
      // }

      final formData = FormData.fromMap({
        'invoice': params.invoice,
        'desc': params.desc,
        if (params.role == 'deliver') 'gudang': 'BARANG JADI',
        '${nameFile}1': await MultipartFile.fromFile(
          params.images![0].path,
          filename: '${nameFile}1.jpg', // ⬅️ selalu tambahkan filename
        ),
        // Collection if: hanya masuk ke map kalau kondisi true
        if (params.images!.length > 1)
          '${nameFile}2': await MultipartFile.fromFile(
            params.images![1].path,
            filename: '${nameFile}2.jpg',
          ),
      });

      String role = params.role!;

      if (params.role == 'loader' && params.statusChecker2 != 'completed') {
        role = 'check2';
      }

      String apiUrl = ApiEndpoints.completeOrder(role);

      if (params.role == 'deliver') {
        role = 'delivery';
        apiUrl = ApiEndpoints.finishScanOrder;
      }

      final response = await dioClient.post(apiUrl, data: formData);

      // debugPrint('Data Ending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelBasic> pendingOrder(ParamsEndingOrder params) async {
    try {
      final formData = FormData.fromMap({
        'invoice': params.invoice,
        'desc': params.desc,
        'foto1': await MultipartFile.fromFile(
          params.images![0].path,
          filename: 'foto1.jpg', // ⬅️ selalu tambahkan filename
        ),
        // Collection if: hanya masuk ke map kalau kondisi true
        if (params.images!.length > 1)
          'foto2': await MultipartFile.fromFile(
            params.images![1].path,
            filename: 'foto2.jpg',
          ),
      });

      String role = params.role!;

      if (params.role == 'loader' && params.statusChecker2 != 'completed') {
        role = 'check2';
      } else if (params.role == 'deliver') {
        role = 'delivery';
      }

      final response = await dioClient.post(
        ApiEndpoints.pendingOrder(role),
        data: formData,
      );

      // debugPrint('Data Pending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelBasic> pendingOrderDriver(ParamsTroubleRIT params) async {
    try {
      // final testDio = Dio(
      //   BaseOptions(
      //     baseUrl: ApiEndpoints.baseUrl,
      //     connectTimeout: const Duration(seconds: 30),
      //     receiveTimeout: const Duration(seconds: 30),
      //     responseType: ResponseType.plain,
      //   ),
      // );

      String jenisTrouble = 'satuan';

      if (params.troubleRIT == EnumTroubleRIT.tolak) {
        jenisTrouble = 'tolak';
      }

      final formData = FormData.fromMap({
        'no_rit': params.noRIT,
        'tanggal_rit': params.tanggalRIT,
        'invoice': params.invoicePO,
        'desc': params.desc,
        'jenis_trouble': jenisTrouble,
        'lat': params.lat,
        'long': params.long,
        if (params.images.isNotEmpty)
          'file1': await MultipartFile.fromFile(
            params.images[0].path,
            filename: 'file1.jpg', // ⬅️ selalu tambahkan filename
          ),
        // Collection if: hanya masuk ke map kalau kondisi true
        if (params.images.length > 1)
          'file2': await MultipartFile.fromFile(
            params.images[1].path,
            filename: 'file2.jpg',
          ),
      });

      // final data = {
      //   'invoice': params.invoicePO,
      //   'desc': params.desc,
      //   'jenis_trouble': jenisTrouble,
      //   'lat': params.lat,
      //   'long': params.long,
      // };

      // debugPrint('📤 TROUBLE FIELDS: ${formData.fields}');
      // debugPrint('📤 TROUBLE FILES: ${formData.files.map((e) => e.key)}');

      // debugPrint('========== TEST REQUEST ==========');

      // for (final field in formData.fields) {
      //   debugPrint('FIELD ${field.key} = ${field.value}');
      // }

      // for (final file in formData.files) {
      //   debugPrint('FILE ${file.key} = ${file.value.filename}');
      // }

      // debugPrint('==================================');

      // debugPrint('Data Pending Order Remote DataSource: ${formData.fields}');

      final response = await dioClient.post(
        ApiEndpoints.trouble,
        data: formData,
      );

      debugPrint('========== RESPONSE ==========');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('CONTENT TYPE: ${response.headers['content-type']}');
      debugPrint('DATA: ${response.data}');
      debugPrint('==============================');

      // debugPrint('📥 STATUS: ${response.statusCode}');
      // debugPrint('📥 DATA: ${response.data}');

      // debugPrint(
      //   'Response Pending Order Remote DataSource: ${response.statusCode}',
      // );

      // debugPrint('Data Pending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      // debugPrint(
      //   'Data Pending Order Remote DataSource Dio: ${e.response?.data}',
      // );
      debugPrint('========== RAW DIO ERROR ==========');
      debugPrint('TYPE: ${e.type}');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('ERROR: ${e.error}');
      debugPrint('STATUS: ${e.response?.statusCode}');
      debugPrint('RESPONSE: ${e.response?.data}');
      debugPrint('URI: ${e.requestOptions.uri}');
      debugPrint('HEADERS: ${e.requestOptions.headers}');
      debugPrint('===================================');

      throw HandleDioExceptions().handleDioError(e);
    } catch (e, stackTrace) {
      debugPrint('Data Pending Order Remote DataSource Catch: $e');
      debugPrint('❌ ERROR TYPE: ${e.runtimeType}');
      debugPrint('❌ ERROR: $e');

      if (e is DioException) {
        debugPrint('❌ DIO TYPE: ${e.type}');
        debugPrint('❌ DIO MESSAGE: ${e.message}');
        debugPrint('❌ DIO ERROR: ${e.error}');
        debugPrint('❌ DIO RESPONSE: ${e.response}');
        debugPrint('❌ STATUS CODE: ${e.response?.statusCode}');
        debugPrint('❌ RESPONSE DATA: ${e.response?.data}');
        debugPrint('❌ RESPONSE HEADERS: ${e.response?.headers}');
        debugPrint('❌ REQUEST OPTIONS: ${e.requestOptions.uri}');
      }

      debugPrint('❌ STACKTRACE: $stackTrace');
      throw ServerException(message: '$e');
    }
  }

  // Pertama kali Driver sampai di Customer Foto Armada & Foto Toko
  @override
  Future<ResponseModelBasic> firstArriveCustomer(
    ParamsEndingOrder params,
  ) async {
    try {
      String nameFile = 'file';
      final imagesTransportation =
          params.imagesDriver?.imagesTransportation ?? [];
      final imagesMerchant = params.imagesDriver?.imagesMerchant ?? [];

      final formData = FormData.fromMap({
        'invoice': params.invoice,
        'desc': params.desc,
        'lat': params.lat,
        'long': params.long,
        if (imagesTransportation.isNotEmpty)
          '${nameFile}1': await MultipartFile.fromFile(
            imagesTransportation[0].path,
            filename: '${nameFile}1.jpg', // ⬅️ selalu tambahkan filename
          ),
        // Collection if: hanya masuk ke map kalau kondisi true
        if (imagesMerchant.isNotEmpty)
          '${nameFile}2': await MultipartFile.fromFile(
            imagesMerchant[0].path,
            filename: '${nameFile}2.jpg',
          ),
      });

      String apiUrl = ApiEndpoints.arriveFirstCustomer;

      final response = await dioClient.post(apiUrl, data: formData);

      // debugPrint('Data Ending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  // Setelah Foto Armada & Foto Toko, Driver mengisikan data untuk pembayaran, ada foto semua barang yang sampai, foto serah terima dan jenis pembayaran
  @override
  Future<ResponseModelBasic> arriveAllItem(ParamsEndingOrder params) async {
    try {
      String nameFile = 'file';
      final imagesAllItem = params.imagesDriver?.imagesAllItem ?? [];

      debugPrint('Send Media File List All Item: ${imagesAllItem.length}');

      final formData = FormData.fromMap({
        'invoice': params.invoice,
        'desc': params.desc,
        'lat': params.lat,
        'long': params.long,
        if (imagesAllItem.isNotEmpty)
          '${nameFile}1': await MultipartFile.fromFile(
            imagesAllItem[0].path,
            filename: '${nameFile}1.jpg', // ⬅️ selalu tambahkan filename
          ),
        // Collection if: hanya masuk ke map kalau kondisi true
        if (imagesAllItem.length > 1)
          '${nameFile}2': await MultipartFile.fromFile(
            imagesAllItem[1].path,
            filename: '${nameFile}2.jpg',
          ),
      });

      String apiUrl = ApiEndpoints.arriveItemCustomer;

      final response = await dioClient.post(apiUrl, data: formData);

      // debugPrint('Data Ending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  // Setelah foto semua barang yang sampai, mengisikan foto serah terima
  @override
  Future<ResponseModelBasic> arriveImageHandover(
    ParamsEndingOrder params,
  ) async {
    try {
      String nameFile = 'file';
      final imagesHandover = params.imagesDriver?.imagesHandover ?? [];

      final formData = FormData.fromMap({
        'invoice': params.invoice,
        'desc': params.desc,
        'lat': params.lat,
        'long': params.long,
        if (imagesHandover.isNotEmpty)
          '${nameFile}1': await MultipartFile.fromFile(
            imagesHandover[0].path,
            filename: '${nameFile}1.jpg', // ⬅️ selalu tambahkan filename
          ),
        // Collection if: hanya masuk ke map kalau kondisi true
        if (imagesHandover.length > 1)
          '${nameFile}2': await MultipartFile.fromFile(
            imagesHandover[1].path,
            filename: '${nameFile}2.jpg',
          ),
      });

      String apiUrl = ApiEndpoints.arriveHandoverCustomer;

      final response = await dioClient.post(apiUrl, data: formData);

      // debugPrint('Data Ending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  // Setelah foto serah terima, mengisikan jenis pembayaran
  @override
  Future<ResponseModelBasic> arrivePaymentCustomer(
    ParamsEndingOrder params,
  ) async {
    try {
      String nameFile = 'file';
      final imagesPayment = params.imagesDriver?.imagesPayment ?? [];

      final formData = FormData.fromMap({
        'invoice': params.invoice,
        'desc': params.desc,
        'lat': params.lat,
        'long': params.long,
        'payment_type': params.paymentMethod,
        'payment_nominal': params.paymentNominal,
        if (imagesPayment.isNotEmpty)
          '${nameFile}1': await MultipartFile.fromFile(
            imagesPayment[0].path,
            filename: '${nameFile}1.jpg', // ⬅️ selalu tambahkan filename
          ),
        // Collection if: hanya masuk ke map kalau kondisi true
        if (imagesPayment.length > 1)
          '${nameFile}2': await MultipartFile.fromFile(
            imagesPayment[1].path,
            filename: '${nameFile}2.jpg',
          ),
      });

      String apiUrl = ApiEndpoints.arrivePaymentCustomer;

      final response = await dioClient.post(apiUrl, data: formData);

      // debugPrint('Data Ending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }
}
