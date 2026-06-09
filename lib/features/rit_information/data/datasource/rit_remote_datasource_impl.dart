import 'package:dio/dio.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../list_order/data/models/response_model_get_transaction_all.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/params/post_rit_param.dart';
import '../models/response_model_rit.dart';
import 'rit_remote_datasource.dart';

class RitRemoteDataSourceImpl implements RitRemoteDataSource {
  final DioClient dioClient;

  RitRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelRit> postSaveDataDriver(ParamsRit params) async {
    try {
      final formData = FormData.fromMap({
        'rit': params.rit,
        'km': params.km,
        'foto_km': '',
        'foto_truck_depan': '',
        'foto_truck_kiri': '',
        'foto_truck_kanan': '',
        'foto_truck_belakang': '',
        'foto_truck_overall': '',
        'foto_truck_tangki': '',
      });

      final response = await dioClient.post(
        ApiEndpoints.saveDataDriver,
        data: formData,
      );

      // debugPrint('Data RIT Transaction Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelRit.fromMap(response.data);
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
  Future<ResponseModelRit> pendingOrder(ParamsRit params) async {
    try {
      // final formData = FormData.fromMap({
      //   'invoice': params.invoice,
      //   'desc': params.desc,
      //   'foto1': await MultipartFile.fromFile(
      //     params.images![0].path,
      //     filename: 'foto1.jpg', // ⬅️ selalu tambahkan filename
      //   ),
      //   // Collection if: hanya masuk ke map kalau kondisi true
      //   if (params.images!.length > 1)
      //     'foto2': await MultipartFile.fromFile(
      //       params.images![1].path,
      //       filename: 'foto2.jpg',
      //     ),
      // });

      // String role = params.role!;

      // if (params.role == 'loader' && params.statusChecker2 != 'completed') {
      //   role = 'check2';
      // } else if (params.role == 'deliver') {
      //   role = 'delivery';
      // }

      final response = await dioClient.post(
        ApiEndpoints.saveDataDriver,
        // data: formData,
      );

      // debugPrint('Data Pending Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelRit.fromMap(response.data);
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
    try {
      Map<String, String> body = {
        if (params.limit != null) 'limit': '${params.limit}',
        if (params.page != null) 'page': '${params.page}',
        if (params.q != null) 'q': '${params.q}',
        if (params.sort != null) 'sort': '${params.sort}',
        if (params.district != null) 'district': '${params.district}',
        if (params.filter != null) 'filter': '${params.filter}',
        if (params.courier != null) 'courier': '${params.courier?.join(',')}',
        if (params.dateRit != null) 'daterit': '${params.dateRit}',
      };

      String queryString = Uri(queryParameters: body).query;
      final response = await dioClient.get(
        '${ApiEndpoints.fetchTransactionAll('all')}?$queryString',
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
}
