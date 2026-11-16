import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/list_order/domain/entities/district_entity.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/filter/filter_datasource_impl.dart';

// ============ INDUK REPOSITORY ============
abstract class FilterRepository {
  Future<ResultCustom<Failure, List<DistrictEntity>>> ritFilter(
    ParamGetRIT param,
  );
}

// ============ CHILD REPOSITORY ============
class FilterRepositoryImpl implements FilterRepository {
  FilterRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  FilterRepositoryImpl(this.dataSource, this.request);

  // ============ GET LIST RIT FILTER ============
  @override
  Future<ResultCustom<Failure, List<DistrictEntity>>> ritFilter(
    ParamGetRIT param,
  ) async {
    return request.execute(
      request: () => dataSource.ritFilter(param),
      mapper: (response) => response.data!.toEntity(),
    );
  }
}
