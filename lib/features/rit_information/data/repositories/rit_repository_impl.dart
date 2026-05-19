import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/entities/rit_entity.dart';
import '../../domain/params/post_rit_param.dart';
import '../../domain/repositories/rit_repository.dart';
import '../datasource/rit_remote_datasource.dart';

class RitRepositoryImpl implements RitRepository {
  RitRemoteDataSource dataSource;

  RitRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, RitEntity>> postEndingOrder(
    ParamsRit params,
  ) async {
    try {
      final response = await dataSource.postSaveDataDriver(params);

      if (response.error == null) {
        return Success(RitEntity(list: []), '');
      }
      return ErrorResult(message: response.error!);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, RitEntity>> pendingOrder(
    ParamsRit params,
  ) async {
    try {
      final response = await dataSource.pendingOrder(params);

      if (response.error == null) {
        return Success(RitEntity(list: []), '');
      }
      return ErrorResult(message: response.error!);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, List<OrderEntity>>> getOrders(
    ParamsGetTransaction params,
  ) async {
    try {
      final response = await dataSource.getOrders(params);

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
