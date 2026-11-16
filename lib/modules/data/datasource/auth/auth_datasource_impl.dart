import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../domain/params/auth/login_param.dart';
import '../../../helpers/api_request_handler.dart';
import '../../models/auth/response_model_login.dart';

// ======== INDUK DATASOURCE ========
abstract class AuthRemoteDataSource {
  Future<ResponseModelLogin> login(LoginParam param);
}

// ======== CHILD DATASOURCE ========
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  AuthRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ POST LOGIN ============
  @override
  Future<ResponseModelLogin> login(LoginParam param) async {
    return apiRequest.execute<ResponseModelLogin>(
      request: () => dioClient.post(
        ApiEndpoints.login,
        data: {"username": param.username, "password": param.password},
      ),
      parser: (parser) => ResponseModelLogin.fromMap(parser),
    );
  }
}
