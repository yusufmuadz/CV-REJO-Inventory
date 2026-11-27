import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/detail_order/domain/entities/basic_entity.dart';
import '../../../../features/detail_order/domain/params/add_assistant_param.dart';
import '../../../../features/list_order/domain/entities/rit_list_entity.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/rit/rit_datasource_impl.dart';

// ============ INDUK REPOSITORY ============
abstract class RitNewRepository {
  Future<ResultCustom<Failure, List<RitListEntity>>> rit(ParamGetRIT param);
  Future<ResultCustom<Failure, BasicEntity>> ambilRit(ParamsAddAssistant param);
}

// ============ CHILD REPOSITORY ============
class RitNewRepositoryImpl implements RitNewRepository {
  RitNewRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  RitNewRepositoryImpl(this.dataSource, this.request);

  // ============ GET LIST RIT TODAY/PAST/SISIPAN ============
  @override
  Future<ResultCustom<Failure, List<RitListEntity>>> rit(
    ParamGetRIT param,
  ) async {
    return request.execute(
      request: () => dataSource.rit(param),
      mapper: (response) => response.data!.toEntity(),
    );
  }

  // ============ POST AMBIL ATAU ADD ASSISTANT RIT TODAY/PAST/SISIPAN ============
  @override
  Future<ResultCustom<Failure, BasicEntity>> ambilRit(
    ParamsAddAssistant param,
  ) async {
    return request.execute(
      request: () => dataSource.ambilRit(param),
      mapper: (response) =>
          BasicEntity(status: response.status, message: response.message),
    );
  }
}
