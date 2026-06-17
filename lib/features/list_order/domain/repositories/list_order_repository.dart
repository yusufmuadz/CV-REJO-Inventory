import 'package:cv_rejo/features/list_order/domain/entities/take_it_order_entity.dart';
import 'package:cv_rejo/features/list_order/domain/params/get_transaction_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../detail_order/domain/entities/basic_entity.dart';
import '../../../detail_order/domain/entities/transportation_entity.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../entities/district_entity.dart';
import '../entities/list_order_entity.dart';
import '../entities/rit_list_entity.dart';
import '../params/get_rit_param.dart';
import '../params/take_it_param.dart';

abstract class ListOrderRepository {
  Future<ResultCustom<Failure, List<OrderEntity>>> getListOrders(
    ParamsGetTransaction params,
  );

  Future<ResultCustom<Failure, List<DistrictEntity>>> getDistrict();

  Future<ResultCustom<Failure, List<RitListEntity>>> getRit(ParamGetRIT param);

  Future<ResultCustom<Failure, List<UserEntity>>> getUsers();
  Future<ResultCustom<Failure, List<TransportationEntity>>>
  getTransportations();

  Future<ResultCustom<Failure, List<TransportationEntity>>>
  getLoaderTransportations();

  Future<ResultCustom<Failure, BasicEntity>> addAssistant(
    ParamsAddAssistant params,
  );
}
