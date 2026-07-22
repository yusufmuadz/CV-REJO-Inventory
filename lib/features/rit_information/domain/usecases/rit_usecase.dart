import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../entities/rit_entity.dart';
import '../params/post_rit_param.dart';
import '../params/trouble_rit_param.dart';
import '../repositories/rit_repository.dart';

class RitUseCase {
  final RitRepository repository;

  RitUseCase(this.repository);

  Future<ResultCustom<Failure, RitEntity>> call(ParamsRit params) {
    return repository.postSaveDataDriver(params);
  }

  Future<ResultCustom<Failure, RitEntity>> postCancelRIT(
    ParamsTroubleRIT params,
  ) {
    return repository.postCancelRIT(params);
  }

  Future<ResultCustom<Failure, List<OrderEntity>>> callGetOrders(
    ParamsGetTransaction params,
  ) {
    return repository.getOrders(params);
  }

  // Future<ResultCustom<Failure, RitEntity>> callPostArriveOfficeDriver(ParamsRit params) {
  //   return repository.postArriveOfficeDriver(params);
  // }
}
