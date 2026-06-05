import 'package:cv_rejo/features/home/domain/entities/home_entity.dart';
import 'package:cv_rejo/features/list_order/domain/params/get_transaction_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  GetHomeUseCase(this.repository);

  Future<ResultCustom<Failure, List<OrderEntity>>> call(ParamsGetTransaction params) {
    return repository.getTransaction(params);
  }

  Future<ResultCustom<Failure, HomeEntity>> callHomeData() {
    return repository.getHomeData();
  }
}
