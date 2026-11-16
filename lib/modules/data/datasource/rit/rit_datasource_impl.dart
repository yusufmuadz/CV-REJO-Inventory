import 'package:intl/intl.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/list_order/data/models/response_model_get_rit.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../helpers/api_request_handler.dart';

// ======== INDUK DATASOURCE ========
abstract class RitNewRemoteDataSource {
  Future<ResponseModelGetRit> rit(ParamGetRIT param);
}

// ======== CHILD DATASOURCE ========
class RitNewRemoteDataSourceImpl implements RitNewRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  RitNewRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET LIST RIT TODAY/PAST/SISIPAN ============
  @override
  Future<ResponseModelGetRit> rit(ParamGetRIT param) {
    if (param.isSisipan == true) {
      return _ritSisipan(param);
    }

    if (param.isPastRit == true) {
      return _ritPast(param);
    }

    return _ritToday(param);
  }

  // ============ GET LIST RIT TODAY ============
  Future<ResponseModelGetRit> _ritToday(ParamGetRIT param) {
    return apiRequest.execute<ResponseModelGetRit>(
      request: () {
        final queryParameters = <String, dynamic>{
          if (param.search != null) 'search': param.search,
        };

        final queryString = Uri(queryParameters: queryParameters).query;

        return dioClient.get('${ApiEndpoints.getRit('getrit')}?$queryString');
      },
      parser: (data) => ResponseModelGetRit.fromMap(data),
    );
  }

  // ============ GET LIST RIT PAST ============
  Future<ResponseModelGetRit> _ritPast(ParamGetRIT param) {
    return apiRequest.execute<ResponseModelGetRit>(
      request: () {
        final date = DateFormat('yyyy-MM-dd').format(
          param.date != null ? DateTime.parse(param.date!) : DateTime.now(),
        );

        final queryParameters = <String, dynamic>{
          if (param.search != null) 'search': param.search,
          'date': date,
        };

        final queryString = Uri(queryParameters: queryParameters).query;

        return dioClient.get('${ApiEndpoints.getRit('pastrit')}?$queryString');
      },
      parser: (data) => ResponseModelGetRit.fromMap(data),
    );
  }

  // ============ GET LIST RIT SISIPAN ============
  Future<ResponseModelGetRit> _ritSisipan(ParamGetRIT param) {
    return apiRequest.execute<ResponseModelGetRit>(
      request: () {
        final date = DateFormat('yyyy-MM-dd').format(
          param.date != null ? DateTime.parse(param.date!) : DateTime.now(),
        );

        final queryParameters = <String, dynamic>{
          if (param.search != null) 'search': param.search,
          'daterit': date,
          'page': param.page,
          'limit': param.limit,
        };

        final queryString = Uri(queryParameters: queryParameters).query;

        return dioClient.get('${ApiEndpoints.fetchRITSisipan}?$queryString');
      },
      parser: (data) => ResponseModelGetRit.fromMap(data),
    );
  }
}
