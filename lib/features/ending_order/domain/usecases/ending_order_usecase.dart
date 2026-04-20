import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/ending_order_entity.dart';
import '../repositories/ending_order_repository.dart';

class EndingOrderUseCase {
  final EndingOrderRepository repository;

  EndingOrderUseCase(this.repository);

  Future<ResultCustom<Failure, EndingOrderEntity>> call(String noInvoice) {
    return repository.getListOrders(noInvoice);
  }
}
