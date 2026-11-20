import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/detail_order/data/models/response_model_get_transporation.dart';
import '../../../../features/ending_order/data/models/response_model_get_payment_method.dart';
import '../../../../features/list_order/data/models/response_model_get_district.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../../features/scan_product/data/models/response_model_get_item_product.dart';
import '../../../helpers/api_request_handler.dart';

// ======== INDUK DATASOURCE ========
abstract class FilterRemoteDataSource {
  Future<ResponseModelGetDistrict> ritFilter(ParamGetRIT param);
  Future<ResponseModelGetTransportation> getTransportations();
  Future<ResponseModelGetItemProduct> getProductItem(String search);
  Future<ResponseModelGetPaymentMethod> getPaymentMethod();
}

// ======== CHILD DATASOURCE ========
class FilterRemoteDataSourceImpl implements FilterRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  FilterRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET LIST RIT UNTUK FILTER ============
  @override
  Future<ResponseModelGetDistrict> ritFilter(ParamGetRIT param) {
    return apiRequest.execute<ResponseModelGetDistrict>(
      request: () {
        final queryParameters = <String, dynamic>{
          if (param.search != null) 'search': param.search,
        };

        final queryString = Uri(queryParameters: queryParameters).query;

        return dioClient.get('${ApiEndpoints.getDistrict}?$queryString');
      },
      parser: (data) => ResponseModelGetDistrict.fromMap(data),
    );
  }

  // ============ GET TRANSPORTASI & LOADER TRANSPORTASI ============
  @override
  Future<ResponseModelGetTransportation> getTransportations() {
    return apiRequest.execute<ResponseModelGetTransportation>(
      request: () {
        String apiEndpoint = AppRole.isChecker2
            ? ApiEndpoints.getLoaderTransportations('')
            : ApiEndpoints.getTransportations('');

        return dioClient.get(apiEndpoint);
      },
      parser: (data) => ResponseModelGetTransportation.fromMap(data),
    );
  }

  // ============ GET LIST PRODUCT ITEM ============
  @override
  Future<ResponseModelGetItemProduct> getProductItem(String search) {
    return apiRequest.execute<ResponseModelGetItemProduct>(
      request: () {
        return dioClient.get(
          ApiEndpoints.getItemProduct,
          queryParameters: {'q': search},
        );
      },
      parser: (data) => ResponseModelGetItemProduct.fromMap(data),
    );
  }

  // ============ GET LIST JENIS PEMBAYARAN ============
  @override
  Future<ResponseModelGetPaymentMethod> getPaymentMethod() {
    return apiRequest.execute<ResponseModelGetPaymentMethod>(
      request: () {
        return dioClient.get(
          ApiEndpoints.getPaymentMethod,
          queryParameters: {'q': ''},
        );
      },
      parser: (data) => ResponseModelGetPaymentMethod.fromMap(data),
    );
  }
}
