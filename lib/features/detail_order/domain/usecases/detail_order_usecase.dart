import 'package:cv_rejo/features/detail_order/domain/entities/basic_entity.dart';
import 'package:cv_rejo/features/detail_order/domain/entities/transportation_entity.dart';
import 'package:cv_rejo/features/detail_order/domain/params/add_assistant_param.dart';
import 'package:cv_rejo/features/detail_order/domain/params/pending_so_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../../scan_product/domain/entities/post_item_product_entity.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../entities/detail_order_entity.dart';
import '../repositories/detail_order_repository.dart';

class DetailOrderUseCase {
  final DetailOrderRepository repository;

  DetailOrderUseCase(this.repository);

  Future<ResultCustom<Failure, DetailOrderEntity>> call(String noInvoice) {
    return repository.getListOrders(noInvoice);
  }

  Future<ResultCustom<Failure, List<UserEntity>>> callUsers() {
    return repository.getUsers();
  }

  Future<ResultCustom<Failure, List<TransportationEntity>>>
  callTransportations() {
    return repository.getTransportations();
  }

  Future<ResultCustom<Failure, List<TransportationEntity>>>
  callLoaderTransportations() {
    return repository.getLoaderTransportations();
  }

  Future<ResultCustom<Failure, BasicEntity>> callPostAssistant(
    ParamsAddAssistant params,
  ) {
    return repository.addAssistant(params);
  }

  Future<ResultCustom<Failure, BasicEntity>> callPendingSO(
    ParamsPendingSO params,
  ) {
    return repository.pendingSO(params);
  }

  Future<ResultCustom<Failure, PostItemProductEntity>> callPostItem(
    ParamsPostProduct params,
  ) {
    return repository.postItemProduct(params);
  }

  Future<ResultCustom<Failure, BasicEntity>> callTakeItTransactionDriver(
    ParamsAddAssistant params,
  ) {
    return repository.takeItTransactionDriver(params);
  }
}
