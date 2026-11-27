import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/detail_order/domain/entities/transportation_entity.dart';
import '../../../../features/ending_order/domain/entities/payment_method_entity.dart';
import '../../../../features/list_order/domain/entities/district_entity.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../../features/scan_product/domain/entities/item_product_entity.dart';
import '../../../data/repositories/master/master_repository_impl.dart';

class MasterUseCase {
  final MasterRepository repository;

  MasterUseCase(this.repository);

  Future<ResultCustom<Failure, List<DistrictEntity>>> callFilterRIT({
    required ParamGetRIT param,
  }) {
    return repository.ritFilter(param);
  }

  Future<ResultCustom<Failure, List<TransportationEntity>>>
  callGetTransportations() {
    return repository.getTransportations();
  }

  Future<ResultCustom<Failure, List<ItemProductEntity>>> callGetItemProduct(
    String search,
  ) {
    return repository.getProductItems(search);
  }

  Future<ResultCustom<Failure, List<PaymentMethodEntity>>>
  callGetPaymentMethods() {
    return repository.getPaymentMethods();
  }
}
