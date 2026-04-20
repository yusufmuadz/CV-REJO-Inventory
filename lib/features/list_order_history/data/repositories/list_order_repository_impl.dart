import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/repositories/list_history_order_repository.dart';
import '../datasource/list_history_order_remote_datasource.dart';

class ListHistoryOrderRepositoryImpl implements ListHistoryOrderRepository {
  ListHistoryOrderRemoteDataSource dataSource;

  ListHistoryOrderRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, List<OrderEntity>>> getListOrders(
    ParamsGetTransaction params,
  ) async {
    try {
      final response = await dataSource.fetchTransaction(params);

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
