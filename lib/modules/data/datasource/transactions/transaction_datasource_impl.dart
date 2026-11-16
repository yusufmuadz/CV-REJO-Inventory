import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../domain/params/auth/login_param.dart';
import '../../../helpers/api_request_handler.dart';
import '../../models/auth/response_model_login.dart';

// ======== INDUK DATASOURCE ========
abstract class TransactionRemoteDataSource {
  Future<ResponseModelLogin> listPO(LoginParam param);
}

// ======== CHILD DATASOURCE ========
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  TransactionRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET LIST PO/TRANSACTION ============
  @override
  Future<ResponseModelLogin> listPO(LoginParam param) async {
    return apiRequest.execute<ResponseModelLogin>(
      request: () => dioClient.post(
        ApiEndpoints.login,
        data: {"username": param.username, "password": param.password},
      ),
      parser: (parser) => ResponseModelLogin.fromMap(parser),
    );
  }
}
