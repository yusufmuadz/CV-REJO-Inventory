
import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/ending_order_entity.dart';

abstract class EndingOrderRepository {
  Future<ResultCustom<Failure, EndingOrderEntity>> getListOrders(
    String noInvoice
  );
}
