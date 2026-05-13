import 'package:cv_rejo/features/list_order/domain/entities/take_it_order_entity.dart';
import 'package:cv_rejo/features/list_order/domain/params/get_transaction_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/district_entity.dart';
import '../entities/list_order_entity.dart';
import '../entities/rit_list_entity.dart';
import '../params/take_it_param.dart';

abstract class ListOrderRepository {
  Future<ResultCustom<Failure, List<OrderEntity>>> getListOrders(
    ParamsGetTransaction params,
  );

  Future<ResultCustom<Failure, TakeItOrderEntity>> takeItTransaction(
    ParamsTakeIt params,
  );

  Future<ResultCustom<Failure, List<DistrictEntity>>> getDistrict();

  Future<ResultCustom<Failure, List<RitListEntity>>> getRit(String search);
}
