import 'package:cv_rejo/features/home/domain/entities/home_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../detail_order/domain/entities/basic_entity.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../params/isi_bbm_param.dart';

abstract class HomeRepository {
  Future<ResultCustom<Failure, List<OrderEntity>>> getTransaction(
    ParamsGetTransaction params,
  );
  Future<ResultCustom<Failure, HomeEntity>> getHomeData();
  Future<ResultCustom<Failure, BasicEntity>> postIsiBbm(ParamsIsiBbm params);
}
