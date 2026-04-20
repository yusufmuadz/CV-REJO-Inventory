import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../repositories/list_history_order_repository.dart';

class ListHistoryOrderUseCase {
  final ListHistoryOrderRepository repository;

  ListHistoryOrderUseCase(this.repository);

  Future<ResultCustom<Failure, List<OrderEntity>>> call(ParamsGetTransaction params) {
    return repository.getListOrders(params);
  }
}
