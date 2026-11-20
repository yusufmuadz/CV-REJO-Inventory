part of '../rit_datasource_impl.dart';

extension RitGetMethods on RitNewRemoteDataSourceImpl {
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
