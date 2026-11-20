import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/list_order/data/models/response_model_get_transaction_all.dart';
import '../../../domain/params/auth/login_param.dart';
import '../../../helpers/api_request_handler.dart';

// ======== INDUK DATASOURCE ========
abstract class TransactionRemoteDataSource {
  Future<ResponseModelGetTransactionAll> getTransactions(LoginParam param);
}

// ======== CHILD DATASOURCE ========
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  TransactionRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET LIST PO/TRANSACTION ============
  @override
  Future<ResponseModelGetTransactionAll> getTransactions(
    LoginParam param,
  ) async {
    return apiRequest.execute<ResponseModelGetTransactionAll>(
      request: () => dioClient.post(
        ApiEndpoints.login,
        data: {"username": param.username, "password": param.password},
      ),
      parser: (parser) => ResponseModelGetTransactionAll.fromMap(parser),
    );
  }
}
