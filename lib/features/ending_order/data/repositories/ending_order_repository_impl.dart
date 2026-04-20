import 'package:cv_rejo/core/result/result_custom.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ending_order_entity.dart';
import '../../domain/repositories/ending_order_repository.dart';
import '../datasource/ending_order_remote_datasource.dart';

class EndingOrderRepositoryImpl implements EndingOrderRepository {
  EndingOrderRemoteDataSource dataSource;

  EndingOrderRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> getListOrders(
    String noInvoice,
  ) async {
    try {
      final response = await dataSource.fetchTransaction(noInvoice);

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
