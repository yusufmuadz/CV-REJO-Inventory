import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/ending_order/domain/params/post_ending_order_param.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../list_order/data/datasource/list_order_remote_datasource.dart';
import '../../../list_order/domain/params/get_rit_param.dart';
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
        String totalPo = '-1';

        if (AppRole.isChecker2 && params.statusChecker2 != 'completed') {
          final rit = GetStorage().read('city');
          final dateRIT = GetStorage().read('tanggalRit');
          final isRitToday = GetStorage().read('isRitToday') ?? false;

          final responseRit = await listOrderDataSource.getRit(
            ParamGetRIT(search: rit, isPastRit: !isRitToday, date: dateRIT),
          );

          final data = responseRit.data;

          if (data != null) {
            final dataTransaction = data.transaction;

            if (dataTransaction != null) {
              totalPo = dataTransaction.first.poPendingCheck2;
            }
          }
        }

        return Success(
          EndingOrderEntity(
            totalPO: totalPo, // totalPO: '0',
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
