import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/list_order/data/datasource/list_order_remote_datasource.dart';
import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/take_it_order_entity.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/repositories/list_order_repository.dart';

class ListOrderRepositoryImpl implements ListOrderRepository {
  ListOrderRemoteDataSource dataSource;

  ListOrderRepositoryImpl(this.dataSource);

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

  @override
  Future<ResultCustom<Failure, TakeItOrderEntity>> takeItTransaction(
    String invoice,
  ) async {
    try {
      final response = await dataSource.takeItTransaction(invoice);

      return Success(TakeItOrderEntity(status: response.status!, message: response.message!), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
