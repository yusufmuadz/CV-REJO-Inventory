import 'package:cv_rejo/features/list_order/domain/entities/take_it_order_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/district_entity.dart';
import '../entities/list_order_entity.dart';
import '../entities/rit_list_entity.dart';
import '../params/get_rit_param.dart';
import '../params/get_transaction_param.dart';
import '../params/take_it_param.dart';
import '../repositories/list_order_repository.dart';

class ListOrderUseCase {
  final ListOrderRepository repository;

  ListOrderUseCase(this.repository);

  Future<ResultCustom<Failure, List<OrderEntity>>> call(
    ParamsGetTransaction params,
  ) {
    return repository.getListOrders(params);
  }

  Future<ResultCustom<Failure, TakeItOrderEntity>> callTakeItTransaction(
    ParamsTakeIt params,
  ) {
    return repository.takeItTransaction(params);
  }

  Future<ResultCustom<Failure, List<DistrictEntity>>> callGetDistrict() {
    return repository.getDistrict();
  }

  Future<ResultCustom<Failure, List<RitListEntity>>> callGetRit(ParamGetRIT param) {
    return repository.getRit(param);
  }
}
