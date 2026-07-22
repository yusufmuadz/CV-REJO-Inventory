import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../entities/rit_entity.dart';
import '../params/trouble_rit_param.dart';
import '../params/post_rit_param.dart';

abstract class RitRepository {
  Future<ResultCustom<Failure, RitEntity>> postSaveDataDriver(ParamsRit params);
  Future<ResultCustom<Failure, RitEntity>> postCancelRIT(
    ParamsTroubleRIT params,
  );
  Future<ResultCustom<Failure, List<OrderEntity>>> getOrders(
    ParamsGetTransaction params,
  );
  // Future<ResultCustom<Failure, RitEntity>> postArriveOfficeDriver(
  //   ParamsRit params,
  // );
}
