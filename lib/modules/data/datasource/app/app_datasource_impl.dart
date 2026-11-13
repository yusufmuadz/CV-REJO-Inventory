import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/home/data/models/response_model_get_home.dart';
import '../../../helpers/api_request_handler.dart';
import '../../models/app/response_model_app_version.dart';

// ======== INDUK DATASOURCE ========
abstract class AppRemoteDataSource {
  Future<ResponseModelGetHome> getHomeData();
  Future<ResponseModelAppVersion> checkVersionApp();
}

// ======== CHILD DATASOURCE ========
class AppRemoteDataSourceImpl implements AppRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  AppRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET MAIN HOME PAGE ============
  @override
  Future<ResponseModelGetHome> getHomeData() async {
    return apiRequest.execute<ResponseModelGetHome>(
      request: () => dioClient.get(ApiEndpoints.home),
      parser: (parser) => ResponseModelGetHome.fromMap(parser),
    );
  }

  // ============ GET VERSION APP ============
  @override
  Future<ResponseModelAppVersion> checkVersionApp() async {
    return apiRequest.execute<ResponseModelAppVersion>(
      request: () =>
          dioClient.get(ApiEndpoints.checkVersion, skipNetworkCheck: true),
      parser: (parser) => ResponseModelAppVersion.fromMap(parser),
    );
  }
}
