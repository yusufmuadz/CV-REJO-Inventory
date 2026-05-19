import 'package:cv_rejo/features/detail_order/domain/entities/basic_entity.dart';
import 'package:cv_rejo/features/detail_order/domain/entities/transportation_entity.dart';
import 'package:cv_rejo/features/detail_order/domain/params/pending_so_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../../scan_product/domain/entities/post_item_product_entity.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../entities/detail_order_entity.dart';
import '../params/add_assistant_param.dart';

abstract class DetailOrderRepository {
  Future<ResultCustom<Failure, DetailOrderEntity>> getListOrders(
    String noInvoice,
  );

  Future<ResultCustom<Failure, List<UserEntity>>> getUsers();
  Future<ResultCustom<Failure, List<TransportationEntity>>>
  getTransportations();

  Future<ResultCustom<Failure, List<TransportationEntity>>>
  getLoaderTransportations();

  Future<ResultCustom<Failure, BasicEntity>> addAssistant(
    ParamsAddAssistant params,
  );
  Future<ResultCustom<Failure, BasicEntity>> pendingSO(ParamsPendingSO params);

  Future<ResultCustom<Failure, PostItemProductEntity>> postItemProduct(
    ParamsPostProduct params,
  );

  Future<ResultCustom<Failure, BasicEntity>> takeItTransactionDriver(
    ParamsAddAssistant params,
  );
}
