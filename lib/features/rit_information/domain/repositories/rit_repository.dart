import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../entities/rit_entity.dart';
import '../params/post_rit_param.dart';

abstract class RitRepository {
  Future<ResultCustom<Failure, RitEntity>> postEndingOrder(
    ParamsRit params,
  );
  Future<ResultCustom<Failure, RitEntity>> pendingOrder(
    ParamsRit params,
  );
  Future<ResultCustom<Failure, List<OrderEntity>>> getOrders(
    ParamsGetTransaction params,
  );
}
