import 'package:cv_rejo/features/list_order/domain/entities/take_it_order_entity.dart';
import 'package:cv_rejo/features/list_order/domain/params/get_transaction_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/list_order_entity.dart';

abstract class ListOrderRepository {
  Future<ResultCustom<Failure, List<OrderEntity>>> getListOrders(
    ParamsGetTransaction params,
  );

  Future<ResultCustom<Failure, TakeItOrderEntity>> takeItTransaction(
    String invoice,
  );
}
