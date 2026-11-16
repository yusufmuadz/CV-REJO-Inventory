import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/list_order/data/models/response_model_get_district.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../helpers/api_request_handler.dart';

// ======== INDUK DATASOURCE ========
abstract class FilterRemoteDataSource {
  Future<ResponseModelGetDistrict> ritFilter(ParamGetRIT param);
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
}
