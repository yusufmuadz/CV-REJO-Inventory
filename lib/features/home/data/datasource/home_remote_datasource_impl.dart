import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/multipart_helper.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../detail_order/data/models/response_model_basic.dart';
import '../../../list_order/data/models/response_model_get_transaction_all.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/params/isi_bbm_param.dart';
import '../models/response_model_get_home.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelGetTransactionAll> fetchTransaction(
    ParamsGetTransaction params,
  ) async {
    try {
      Map<String, String> body = {
        if (params.limit != null) 'limit': '${params.limit}',
        if (params.page != null) 'page': '${params.page}',
        if (params.filter != null) 'filter': '${params.filter}',
        if (params.district != null) 'district': '${params.district}',
        if (params.dateRit != null) 'date_rit': '${params.dateRit}',
      };

      String queryString = Uri(queryParameters: body).query;
      String apiUrl = '${ApiEndpoints.fetchTransactionAll('all')}?$queryString';

      if (AppRole.isChecker2 && params.isTracking == true) {
        apiUrl = '${ApiEndpoints.fetchTransactionTracking}?$queryString';
      }

      final response = await dioClient.get(apiUrl);

      // debugPrint('Data Home Transaction Remote DataSource: ${response.data['data']}');

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  @override
  Future<ResponseModelGetHome> getHomeData() async {
    try {
      final response = await dioClient.get(ApiEndpoints.home);

      // debugPrint('Data Home Remote DataSource: ${response.data['data']}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModelGetHome.fromMap(response.data);
      } else {
        return ResponseModelGetHome.fromMap({
          'status': false,
          'message': '',
          'data': [],
        });
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelBasic> postIsiBbm(ParamsIsiBbm params) async {
    try {
      final formData = FormData.fromMap({
        'no_rit': params.noRit,
        'tanggal_rit': params.dateRit,
        'km': params.fieldKm,
        'nopol': params.fieldNopol,
        'payment_type': params.paymentMethod ?? 'cash',
        'payment_nominal': params.paymentNominal ?? 0,
        'desc': params.fieldDesc,
        'lat': params.lat,
        'long': params.long,
        'file_segel_sebelum': await MultipartHelper.fromNullableXFile(
          params.imagesSealBefore?[0],
        ),
        'file_segel_sesudah': await MultipartHelper.fromNullableXFile(
          params.imagesSealAfter?[0],
        ),
        'file_bukti_pembayaran': await MultipartHelper.fromNullableXFile(
          params.imagesBuktiPembayaran?[0],
        ),
        'file_depan': await MultipartHelper.fromNullableXFile(
          params.imagesFrontTransportation?[0],
        ),
        'file_dispenser_awal': await MultipartHelper.fromNullableXFile(
          params.imagesDispenserAwal?[0],
        ),
        'file_dispenser_akhir': await MultipartHelper.fromNullableXFile(
          params.imagesDispenserAkhir?[0],
        ),
        'file_pengisian_full': await MultipartHelper.fromNullableXFile(
          params.imagesPengisianFull?[0],
        ),
      });

      debugPrint(formData.fields.toString());
      debugPrint(formData.files.toString());

      // throw ServerException(message: 'Test Post', statusCode: 500);

      final response = await dioClient.post(
        ApiEndpoints.isiBbm,
        data: formData,
        // headers: {
        //   'Accept': 'application/json',
        //   'Content-Type': 'application/json',
        //   'Authorization':
        //       'Bearer g08udjem/KBXpwHOYb3dkh3dFpSTnZZU3ZPVjc2ZGg2Yk9VSzltTWs0NW0vZXpHWTBmK2FpV1hoR3hWNDJTS2xvRHNoQVhKR3BVODEwelRhZklZbFlUV1hDMW1LTW45WWJocTBjZ2VncXhJbkZESUJpSFFwRWNqb1g1eDUwN1d4Sjlta0VuYlRjb0tNMnBUNmFWaUVjWW5FR2kwOXI5UitpbkhqMGo0QnNUOUtvdVJMU3hWVTE2bngrSWJxZHdadjViRFVmQnNLM0lZTS93Wg==',
        // },
      );

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
