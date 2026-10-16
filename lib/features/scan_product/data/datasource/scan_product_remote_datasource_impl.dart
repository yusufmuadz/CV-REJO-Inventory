import 'package:cv_rejo/features/scan_product/domain/params/scan_product_param.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/params/post_product_param.dart';
import '../models/response_model_get_item_product.dart';
import '../models/response_model_post_item_product.dart';
import '../models/response_model_scan_product.dart';
import 'scan_product_remote_datasource.dart';

class ScanProductRemoteDataSourceImpl implements ScanProductRemoteDataSource {
  final DioClient dioClient;

  ScanProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelScanProduct> getProduct(ParamsGetProduct params) async {
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
      throw ServerException(message: '$e');
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
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelPostItemProduct> postItemProduct(
    ParamsPostProduct params,
  ) async {
    try {
      final formData = FormData.fromMap({
        'barcode': params.barcode,
        'invoice': params.invoice,
        'qty': params.qty,
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
      }

      if (params.role == 'deliver') {
        role = 'deliverynew';
      }

      final response = await dioClient.post(
        ApiEndpoints.saveQty(role),
        data: formData,
        // headers: {
        //   'Accept': 'application/json',
        //   'Content-Type': 'application/json',
        //   'Authorization':
        //       'Bearer cJhGxx+OmXVsd7jmyRC7GS9GWVZVQUZjaStuK0NsekJqOGViRTJnWmJYbGg2K3ZQSUUwTFFPbUtmWURlakVyelZwcUN5YmNFOElZYjJUa2o0RmtlbkN1V2RNYVY0MEx0U09TaXRJSDhqbXJUSDJ3L05wZ3dNMTlYaUNuZEFDTWFCcEFwQXFaL3huYnByZWwraE8rbGRKUGtoLzc4MXBRMHJsNldXeTJmd2x2TUdHQzIxRTY0bTlZUHF5cFM3ZHRhVGJEd2ptSGcrNndaOFFyVnh2c1o1dGNnN04zLzZYZDVPcWNtRUsxWFhZWTQxYlVTclI3ZmIvSU9NWXM9',
        // },
      );

      // debugPrint('Data POST Item Product Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelPostItemProduct.fromMap(response.data);
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
