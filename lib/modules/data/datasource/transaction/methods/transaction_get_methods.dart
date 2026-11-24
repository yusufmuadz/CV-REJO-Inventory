part of '../transaction_datasource_impl.dart';

extension TransactionGetMethods on TransactionRemoteDataSourceImpl {
  // ============ GET LIST PO/TRANSACTION ALL ============
  Future<ResponseModelGetTransactionAll> _fetchAllTransaction(
    ParamsGetTransaction params,
  ) {
    return _executeTransaction(ApiEndpoints.fetchTransactionAll('all'), params);
  }

  // ============ GET LIST PO/TRANSACTION PAST ============
  Future<ResponseModelGetTransactionAll> _fetchPastTransaction(
    ParamsGetTransaction params,
  ) {
    return _executeTransaction(
      ApiEndpoints.fetchTransactionAll('past'),
      params,
    );
  }

  // ============ GET LIST PO/TRANSACTION HISTORY ============
  Future<ResponseModelGetTransactionAll> _fetchHistoryTransaction(
    ParamsGetTransaction params,
  ) {
    String apiEndPoint = ApiEndpoints.fetchHistoryTransaction;

    if (AppRole.isCollector) {
      apiEndPoint = ApiEndpoints.historyCollector;
    }

    return _executeTransaction(apiEndPoint, params);
  }

  // ============ GET LIST PO/TRANSACTION TRACKING DRIVER ============
  Future<ResponseModelGetTransactionAll> _fetchTransactionTracking(
    ParamsGetTransaction params,
  ) {
    return _executeTransaction(ApiEndpoints.fetchTransactionTracking, params);
  }

  // ============ GET LIST PO/TRANSACTION SISIPAN ============
  Future<ResponseModelGetTransactionAll> _fetchTransactionSisipan(
    ParamsGetTransaction params,
  ) {
    return _executeTransaction(ApiEndpoints.fetchTransactionSisipan, params);
  }

  // ============ EXECUTE REQUEST GET LIST PO/TRANSACTION ALL ============
  Future<ResponseModelGetTransactionAll> _executeTransaction(
    String endpoint,
    ParamsGetTransaction params,
  ) {
    final query = _buildTransactionQuery(params);
    final queryString = Uri(queryParameters: query).query;

    return apiRequest.execute<ResponseModelGetTransactionAll>(
      request: () => dioClient.get('$endpoint?$queryString'),
      parser: (data) => ResponseModelGetTransactionAll.fromMap(data),
    );
  }

  // ============ BUILD QUERY PARAMETERS GET LIST PO/TRANSACTION ALL ============
  Map<String, String> _buildTransactionQuery(ParamsGetTransaction params) {
    final isPast = params.pastRit == true;

    String? date = params.dateRit;

    if (isPast || date != null) {
      date = DateFormat(
        'yyyy-MM-dd',
      ).format(date != null ? DateTime.parse(date) : DateTime.now());
    }

    return {
      if (params.limit != null) 'limit': '${params.limit}',
      if (params.page != null) 'page': '${params.page}',
      if (!AppRole.isCollector && params.isHistory == false) ...{
        if (params.q != null) 'q': params.q!,
        if (params.sort?.isNotEmpty == true) 'sort': params.sort!,
        if (params.district != null) 'district': params.district!,
        if (params.filter != null) 'filter': params.filter!,
        if (params.courier != null) 'courier': params.courier!.join(','),
        if (params.dateRit != null) 'date_rit': date!,
      } else ...{
        if (params.q != null) 'nota_rute': params.q!,
        if (params.sort?.isNotEmpty == true) 'status': params.sort!,
      },
    };
  }
}
