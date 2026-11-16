import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/list_order/domain/entities/rit_list_entity.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/rit/rit_datasource_impl.dart';

// ============ INDUK REPOSITORY ============
abstract class RitNewRepository {
  Future<ResultCustom<Failure, List<RitListEntity>>> rit(ParamGetRIT param);
}

// ============ CHILD REPOSITORY ============
class RitNewRepositoryImpl implements RitNewRepository {
  RitNewRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  RitNewRepositoryImpl(this.dataSource, this.request);

  // ============ GET LIST RIT TODAY/PAST ============
  @override
  Future<ResultCustom<Failure, List<RitListEntity>>> rit(
    ParamGetRIT param,
  ) async {
    return request.execute(
      request: () => dataSource.rit(param),
      mapper: (response) => response.data!.toEntity(),
    );
  }
}
