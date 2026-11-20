import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/detail_order/data/models/response_model_get_user.dart';
import '../../../helpers/api_request_handler.dart';
import '../../models/users/response_model_get_user_login.dart';

// ======== INDUK DATASOURCE ========
abstract class UserRemoteDataSource {
  Future<ResponseModelGetUser> listUser();
  Future<ResponseModelGetUserLogin> user();
}

// ======== CHILD DATASOURCE ========
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  UserRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET LIST USER ============
  @override
  Future<ResponseModelGetUser> listUser() async {
    return apiRequest.execute<ResponseModelGetUser>(
      request: () => dioClient.get(ApiEndpoints.getUsers),
      parser: (parser) => ResponseModelGetUser.fromMap(parser),
    );
  }

  // ============ GET USER LOGIN ============
  @override
  Future<ResponseModelGetUserLogin> user() async {
    return apiRequest.execute<ResponseModelGetUserLogin>(
      request: () => dioClient.get(ApiEndpoints.userDetail),
      parser: (parser) => ResponseModelGetUserLogin.fromMap(parser),
    );
  }
}
