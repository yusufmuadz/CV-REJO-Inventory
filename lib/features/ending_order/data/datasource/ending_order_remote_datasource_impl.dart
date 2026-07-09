import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../rit_information/domain/params/trouble_rit_param.dart';
import '../../domain/params/post_ending_order_param.dart';
import '../models/response_model_ending_order.dart';
import 'ending_order_remote_datasource.dart';

class EndingOrderRemoteDataSourceImpl implements EndingOrderRemoteDataSource {
  final DioClient dioClient;

  EndingOrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelEndingOrder> postEndingOrder(
    ParamsEndingOrder params,
  ) async {
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
        return ResponseModelEndingOrder.fromMap(response.data);
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
  Future<ResponseModelEndingOrder> pendingOrder(
    ParamsEndingOrder params,
  ) async {
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
        return ResponseModelEndingOrder.fromMap(response.data);
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
  Future<ResponseModelEndingOrder> pendingOrderDriver(ParamsTroubleRIT params) async {
    try {
      final formData = FormData.fromMap({
        'invoice': params.invoicePO,
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
        return ResponseModelEndingOrder.fromMap(response.data);
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
