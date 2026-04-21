import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/ending_order_entity.dart';
import '../params/post_ending_order_param.dart';
import '../repositories/ending_order_repository.dart';

class EndingOrderUseCase {
  final EndingOrderRepository repository;

  EndingOrderUseCase(this.repository);

  Future<ResultCustom<Failure, EndingOrderEntity>> call(ParamsEndingOrder params) {
    return repository.postEndingOrder(params);
  }
}
