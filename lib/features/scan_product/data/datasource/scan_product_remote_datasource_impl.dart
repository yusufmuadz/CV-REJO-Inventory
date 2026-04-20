import 'package:cv_rejo/features/scan_product/domain/params/scan_product_param.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/response_model_get_item_product.dart';
import '../models/response_model_scan_product.dart';
import 'scan_product_remote_datasource.dart';

class ScanProductRemoteDataSourceImpl implements ScanProductRemoteDataSource {
  final DioClient dioClient;

  ScanProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelScanProduct> getProduct(ParamsGetproduct params) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.getScanProduct(params.role?.toLowerCase() ?? 'picking'),
        data: {'barcode': params.barcode, 'invoice': params.invoice},
      );

      // debugPrint('Data Scan Product Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelScanProduct.fromMap(response.data);
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

  @override
  Future<ResponseModelGetItemProduct> getItemProduct(String search) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.getItemProduct,
        queryParameters: {'q': search},
      );

      // debugPrint('Data Item Product Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetItemProduct.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error Get Item Product: $e');
    }
  }
}
