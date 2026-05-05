import 'package:cv_rejo/features/detail_order/data/models/response_model_detail_order.dart';
import 'package:cv_rejo/features/detail_order/data/models/response_model_get_transporation.dart';
import 'package:cv_rejo/features/detail_order/data/models/response_model_basic.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../scan_product/data/models/response_model_post_item_product.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../../domain/params/add_assistant_param.dart';
import '../../domain/params/pending_so_param.dart';
import '../models/response_model_get_user.dart';
import 'detail_order_remote_datasource.dart';

class DetailOrderRemoteDataSourceImpl implements DetailOrderRemoteDataSource {
  final DioClient dioClient;

  DetailOrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelDetailOrder> fetchTransaction(String noInvoice) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.getDetailTransaction(noInvoice),
      );

      // debugPrint('Data Detail Order Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelDetailOrder.fromMap(response.data);
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
  Future<ResponseModelGetUser> getUsers() async {
    try {
      final response = await dioClient.get(ApiEndpoints.getUsers);

      // debugPrint('Data Get Users Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetUser.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error Get Users: $e');
    }
  }

  @override
  Future<ResponseModelGetTransportation> getTransportations() async {
    try {
      String apiEndpoint = ApiEndpoints.getTransportations('');

      if (AppRole.isChecker2) {
        apiEndpoint = ApiEndpoints.getLoaderTransportations('');
      }

      final response = await dioClient.get(apiEndpoint);

      // debugPrint('Data Get Users Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetTransportation.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error Get Transportations: $e');
    }
  }

  @override
  Future<ResponseModelGetTransportation> getLoaderTransportations() async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.getLoaderTransportations(''),
      );

      // debugPrint('Data Get Loader Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetTransportation.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error Get Loader Transportations: $e');
    }
  }

  @override
  Future<ResponseModelBasic> addAssistant(ParamsAddAssistant params) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.addAssistant,
        data: {
          "invoice": params.invoice,
          "id_loader": params.idLoader,
          "id_driver": params.idDriver,
          "id_kenek": params.idKenek,
        },
      );

      // debugPrint('Data Add Assistant Remote DataSource: ${response.data}');

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
      throw ServerException(message: 'error Add Assistant: $e');
    }
  }

  @override
  Future<ResponseModelBasic> pendingSO(ParamsPendingSO params) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.pendingSO,
        data: {"invoice": params.invoice},
      );

      // debugPrint('Data Pending SO Remote DataSource: ${response.data}');

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
      throw ServerException(message: 'error Pending SO: $e');
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

      final response = await dioClient.post(
        ApiEndpoints.saveQty(role),
        data: formData,
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
      throw ServerException(message: 'error POST Item Product: $e');
    }
  }
}
