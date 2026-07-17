import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../rit_information/domain/params/trouble_rit_param.dart';
import '../../presentation/controllers/enums/enum_button.dart';
import '../entities/ending_order_entity.dart';
import '../params/post_ending_order_param.dart';

abstract class EndingOrderRepository {
  Future<ResultCustom<Failure, EndingOrderEntity>> postEndingOrder(
    ParamsEndingOrder params,
  );
  Future<ResultCustom<Failure, EndingOrderEntity>> pendingOrder(
    ParamsEndingOrder params,
  );

  Future<ResultCustom<Failure, EndingOrderEntity>> pendingOrderDriver(
    ParamsTroubleRIT params,
  );

  Future<ResultCustom<Failure, EndingOrderEntity>> arriveDriver(
    ParamsEndingOrder params,
    EnumButtonEndingOrder statusButton,
  );
}
