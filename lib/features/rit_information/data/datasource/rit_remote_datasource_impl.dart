import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/multipart_extension.dart';
import '../../../../core/helpers/multipart_helper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../detail_order/data/models/response_model_basic.dart';
import '../../../list_order/data/models/response_model_get_transaction_all.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/params/trouble_rit_param.dart';
import '../../domain/params/post_rit_param.dart';
import 'rit_remote_datasource.dart';

class RitRemoteDataSourceImpl implements RitRemoteDataSource {
  final DioClient dioClient;

  RitRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelBasic> postSaveDataDriver(ParamsRit params) async {
    try {
      String date = params.dateRit;

      if (date.isNotEmpty) {
        date = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
        debugPrint('Date HandOver: $date');
      }

      final formData = FormData.fromMap({
        'nama_penerima': params.recipient,
        'rit': params.rit,
        'tanggal_rit': date,
        'km': params.km,
        'foto_km': await params.kmImage.multipart,
        'foto_truck_depan': await MultipartHelper.fromNullableXFile(
          params.frontTruckImage,
        ),
        'foto_truck_kiri': await MultipartHelper.fromNullableXFile(
          params.leftTruckImage,
        ),
        'foto_truck_kanan': await MultipartHelper.fromNullableXFile(
          params.rightTruckImage,
        ),
        'foto_truck_belakang': await MultipartHelper.fromNullableXFile(
          params.backTruckImage,
        ),
        'foto_truck_overall': await MultipartHelper.fromNullableXFile(
          params.overAllTruckImage,
        ),
        'foto_truck_tangki': await MultipartHelper.fromNullableXFile(
          params.tankTruckImage,
        ),
        'foto_truck_sj': await MultipartHelper.fromNullableXFile(
          params.travelDocImage,
        ),
        'foto_truck_uang': await MultipartHelper.fromNullableXFile(
          params.pocketImage,
        ),
        if (params.isArriveOffice == true) 'tanggal_rit': params.dateRit,
        if (params.isArriveOffice == true)
          'foto_bukti_tf': await MultipartHelper.fromNullableXFile(
            params.receiptMoneyImage,
          ),
        if (params.isArriveOffice == true)
          'foto_kotak_berkas': await MultipartHelper.fromNullableXFile(
            params.fileBoxImage,
          ),
      });

      debugPrint(formData.fields.toString());

      String apiUrl = ApiEndpoints.saveDataDriver;

      if (params.isArriveOffice == true) {
        apiUrl = ApiEndpoints.arriveAtOffice;
      }

      final response = await dioClient.post(
        apiUrl,
        data: formData,
        contentType: Headers.multipartFormDataContentType,
      );

      // debugPrint('Data RIT Transaction Remote DataSource: ${response.data}');

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
  Future<ResponseModelBasic> postCancelRIT(ParamsTroubleRIT params) async {
    try {
      String? date = params.tanggalRIT;

      if (date.isNotEmpty) {
        date = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
      }

      final formData = FormData.fromMap({
        'no_rit': params.noRIT,
        'tanggal_rit': date,
        'desc': params.desc,
        'jenis_trouble': params.troubleRIT,
        'lat': params.lat,
        'long': params.long,
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

      final response = await dioClient.post(
        ApiEndpoints.trouble,
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
  Future<ResponseModelGetTransactionAll> getOrders(
    ParamsGetTransaction params,
  ) async {
    String? date = params.dateRit;

    if (date != null) {
      if (date.isNotEmpty) {
        date = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
      }
    }

    try {
      Map<String, String> body = {
        if (params.limit != null) 'limit': '${params.limit}',
        if (params.page != null) 'page': '${params.page}',
        if (params.q != null) 'q': '${params.q}',
        if (params.sort != null) 'sort': '${params.sort}',
        if (params.district != null) 'district': '${params.district}',
        if (params.filter != null) 'filter': '${params.filter}',
        if (params.courier != null) 'courier': '${params.courier?.join(',')}',
        if (params.dateRit != null) 'date_rit': '$date',
      };

      String queryString = Uri(queryParameters: body).query;

      String url = 'all';

      if (params.pastRit == true) {
        url = 'past';
      }

      final response = await dioClient.get(
        '${ApiEndpoints.fetchTransactionAll(url)}?$queryString',
      );

      // debugPrint('Data Home Get Transaction Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetTransactionAll.fromMap(response.data);
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

  // @override
  // Future<ResponseModelBasic> postArriveOfficeDriver(ParamsRit params) async {
  //   try {
  //     final formData = FormData.fromMap({
  //       'rit': params.rit,
  //       'tanggal_rit': params.dateRit,
  //       'km': params.km,
  //       'foto_km': params.kmImage,
  //       'foto_truck_depan': params.frontTruckImage,
  //       'foto_truck_kiri': params.leftTruckImage,
  //       'foto_truck_kanan': params.rightTruckImage,
  //       'foto_truck_belakang': params.backTruckImage,
  //       // 'foto_truck_overall': params.overAllTruckImage,
  //       'foto_truck_tangki': params.tankTruckImage,
  //       'foto_truck_sj': params.travelDocImage,
  //       'foto_truck_uang': params.pocketImage,
  //       'foto_bukti_tf': params.receiptMoneyImage,
  //       'foto_kotak_berkas': params.fileBoxImage,
  //     });

  //     final response = await dioClient.post(
  //       ApiEndpoints.arriveAtOffice,
  //       data: formData,
  //     );

  //     // debugPrint('Data RIT Transaction Remote DataSource: ${response.data}');

  //     if (response.statusCode == 200 ||
  //         response.statusCode == 201 ||
  //         response.data != null) {
  //       return ResponseModelBasic.fromMap(response.data);
  //     } else {
  //       throw ServerException(
  //         message: response.data['message'],
  //         statusCode: response.statusCode ?? 500,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw HandleDioExceptions().handleDioError(e);
  //   } catch (e) {
  //     throw ServerException(message: '$e');
  //   }
  // }
}
