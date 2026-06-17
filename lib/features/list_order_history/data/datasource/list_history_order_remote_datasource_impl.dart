import 'package:dio/dio.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../list_order/data/models/response_model_get_district.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../models/response_model_get_history_order.dart';
import 'list_history_order_remote_datasource.dart';

class ListHistoryOrderRemoteDataSourceImpl
    implements ListHistoryOrderRemoteDataSource {
  final DioClient dioClient;

  ListHistoryOrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelHistoryOrderAll> fetchTransaction(
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
        if (params.dateRit != null) 'date_rit': '${params.dateRit}',
      };

      String queryString = Uri(queryParameters: body).query;
      final response = await dioClient.get(
        '${ApiEndpoints.fetchHistoryTransaction}?$queryString',
      );

      // debugPrint('Data List History Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelHistoryOrderAll.fromMap(response.data);
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
  Future<ResponseModelGetDistrict> getDistrict() async {
    try {
      final response = await dioClient.get(ApiEndpoints.getDistrict);

      // debugPrint('Data Get District Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetDistrict.fromMap(response.data);
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
