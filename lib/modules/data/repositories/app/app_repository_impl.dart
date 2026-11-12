import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/home/domain/entities/home_entity.dart';
import '../../../domain/entities/app/version_entity.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/app/app_datasource_impl.dart';

// ============ INDUK REPOSITORY ============
abstract class AppRepository {
  Future<ResultCustom<Failure, HomeEntity>> getHomeData();
  Future<ResultCustom<Failure, VersionEntity>> checkVersionApp();
}

// ============ CHILD REPOSITORY ============
class AppRepositoryImpl implements AppRepository {
  AppRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  AppRepositoryImpl(this.dataSource, this.request);

  // ============ GET MAIN HOME PAGE ============
  @override
  Future<ResultCustom<Failure, HomeEntity>> getHomeData() async {
    return request.execute(
      request: () => dataSource.getHomeData(),
      mapper: (response) => response.data!.toEntity(),
    );
  }

  // ============ GET VERSION APP ============
  @override
  Future<ResultCustom<Failure, VersionEntity>> checkVersionApp() async {
    return request.execute(
      request: () => dataSource.checkVersionApp(),
      mapper: (response) => response.data!.toEntity(),
    );
  }
}
