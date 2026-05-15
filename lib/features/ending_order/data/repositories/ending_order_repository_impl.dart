import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/ending_order/domain/params/post_ending_order_param.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/error/failures.dart';
import '../../../list_order/data/datasource/list_order_remote_datasource.dart';
import '../../domain/entities/ending_order_entity.dart';
import '../../domain/repositories/ending_order_repository.dart';
import '../datasource/ending_order_remote_datasource.dart';

class EndingOrderRepositoryImpl implements EndingOrderRepository {
  EndingOrderRemoteDataSource dataSource;
  ListOrderRemoteDataSource listOrderDataSource;

  EndingOrderRepositoryImpl(this.dataSource, this.listOrderDataSource);

  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> postEndingOrder(
    ParamsEndingOrder params,
  ) async {
    try {
      final response = await dataSource.postEndingOrder(params);

      if (response.error == null) {
        final rit = GetStorage().read('city');
        final responseRit = await listOrderDataSource.getRit(rit);

        return Success(
          EndingOrderEntity(
            totalPO: responseRit.data!.transaction!.first.poPendingDelivery,
            list: [],
          ),
          '',
        );
      }
      return ErrorResult(message: response.error!);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> pendingOrder(
    ParamsEndingOrder params,
  ) async {
    try {
      final response = await dataSource.pendingOrder(params);

      if (response.error == null) {
        return Success(EndingOrderEntity(list: []), '');
      }
      return ErrorResult(message: response.error!);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
