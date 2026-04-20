import 'package:cv_rejo/features/home/domain/entities/home_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/transaction_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';

abstract class HomeRepository {
  Future<ResultCustom<Failure, TransactionEntity>> getTransaction(
    ParamsGetTransaction params,
  );
  Future<ResultCustom<Failure, HomeEntity>> getHomeData();
}
