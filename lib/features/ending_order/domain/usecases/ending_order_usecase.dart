import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../rit_information/domain/params/trouble_rit_param.dart';
import '../entities/ending_order_entity.dart';
import '../params/post_ending_order_param.dart';
import '../repositories/ending_order_repository.dart';

class EndingOrderUseCase {
  final EndingOrderRepository repository;

  EndingOrderUseCase(this.repository);

  Future<ResultCustom<Failure, EndingOrderEntity>> call(
    ParamsEndingOrder params,
  ) {
    return repository.postEndingOrder(params);
  }

  Future<ResultCustom<Failure, EndingOrderEntity>> callPendingOrder(
    ParamsEndingOrder params,
  ) {
    return repository.pendingOrder(params);
  }

  Future<ResultCustom<Failure, EndingOrderEntity>> callPendingOrderDriver(
    ParamsTroubleRIT params,
  ) {
    return repository.pendingOrderDriver(params);
  }
}
