part of '../transaction_datasource_impl.dart';

extension TransactionDetailMethods on TransactionRemoteDataSourceImpl {
  // ============ GET DETAIL PO/TRANSACTION ============
  Future<ResponseModelDetailOrder> _getDetailTransaction(
    ParamsGetDetail param,
  ) {
    return apiRequest.execute<ResponseModelDetailOrder>(
      request: () {
        String apiEndpoint = ApiEndpoints.getDetailTransaction(param.invoice);

        if (AppRole.isCollector) {
          apiEndpoint = ApiEndpoints.getDetailTransactionCollector(
            param.idDetail,
          );
        }

        return dioClient.get(apiEndpoint);
      },
      parser: (data) => ResponseModelDetailOrder.fromMap(data),
    );
  }

  // ============ AMBIL PO/TRANSACTION DEFAULT ============
  Future<ResponseModelBasic> _ambilTransactionDefault(ParamsTakeIt param) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () {
        String role = param.role;

        if (param.role == 'loader' && param.statusChecker2 != 'completed') {
          role = 'check2';
        }

        return dioClient.put(
          ApiEndpoints.takeItTransaction(role),
          data: {"invoice": param.invoice},
        );
      },
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }

  // ============ AMBIL PO/TRANSACTION DRIVER ============
  Future<ResponseModelBasic> _ambilTransactionDriver(ParamsTakeIt param) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () {
        return dioClient.post(
          ApiEndpoints.takeItTransactionDriver,
          contentType: Headers.formUrlEncodedContentType,
          data: {"invoice": param.invoice.toString().trim()},
        );
      },
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }
}
