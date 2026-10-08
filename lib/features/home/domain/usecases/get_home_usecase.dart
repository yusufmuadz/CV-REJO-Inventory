import 'package:cv_rejo/features/home/domain/entities/home_entity.dart';
import 'package:cv_rejo/features/list_order/domain/params/get_transaction_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../detail_order/domain/entities/basic_entity.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../../../list_order/domain/params/get_rit_param.dart';
import '../params/isi_bbm_param.dart';
import '../repositories/home_repository.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  GetHomeUseCase(this.repository);

  Future<ResultCustom<Failure, List<OrderEntity>>> call(
    ParamsGetTransaction params,
  ) {
    return repository.getTransaction(params);
  }

  Future<ResultCustom<Failure, List<RitListEntity>>> callGetRIT(
    ParamGetRIT params,
  ) {
    return repository.getRit(params);
  }

  Future<ResultCustom<Failure, HomeEntity>> callHomeData() {
    return repository.getHomeData();
  }

  Future<ResultCustom<Failure, BasicEntity>> callPostIsiBbm(
    ParamsIsiBbm params,
  ) {
    return repository.postIsiBbm(params);
  }
}
