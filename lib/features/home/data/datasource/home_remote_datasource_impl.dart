import 'package:dio/dio.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../list_order/data/models/response_model_get_transaction.dart';
import '../../../list_order/data/models/response_model_get_transaction_all.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
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
        if (params.dateRit != null) 'date_rit': '${params.dateRit}',
      };

      String queryString = Uri(queryParameters: body).query;
      final response = await dioClient.get(
        '${ApiEndpoints.fetchTransactionAll('all')}?$queryString',
      );

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
}
