import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/ending_order_entity.dart';
import '../params/post_ending_order_param.dart';

abstract class EndingOrderRepository {
  Future<ResultCustom<Failure, EndingOrderEntity>> postEndingOrder(
    ParamsEndingOrder params,
  );
}
