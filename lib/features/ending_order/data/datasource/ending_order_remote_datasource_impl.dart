import 'package:dio/dio.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/response_model_ending_order.dart';
import 'ending_order_remote_datasource.dart';

class EndingOrderRemoteDataSourceImpl implements EndingOrderRemoteDataSource {
  final DioClient dioClient;

  EndingOrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelEndingOrder> fetchTransaction(String noInvoice) async {
    try {
      final response = await dioClient.post('');

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
      throw ServerException(message: 'error Home Transaction: $e');
    }
  }
}
