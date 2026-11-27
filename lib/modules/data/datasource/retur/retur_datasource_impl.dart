import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/home/data/models/response_model_get_home.dart';
import '../../../helpers/api_request_handler.dart';

// ======== INDUK DATASOURCE ========
abstract class ReturRemoteDataSource {
  Future<ResponseModelGetHome> getHomeData();
}

// ======== CHILD DATASOURCE ========
class ReturRemoteDataSourceImpl implements ReturRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  ReturRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET MAIN HOME PAGE ============
  @override
  Future<ResponseModelGetHome> getHomeData() async {
    return apiRequest.execute<ResponseModelGetHome>(
      request: () => dioClient.get(ApiEndpoints.home),
      parser: (parser) => ResponseModelGetHome.fromMap(parser),
    );
  }
}
