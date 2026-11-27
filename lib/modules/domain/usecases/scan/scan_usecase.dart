import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/scan_product/domain/entities/post_item_product_entity.dart';
import '../../../../features/scan_product/domain/entities/scan_product_entity.dart';
import '../../../../features/scan_product/domain/params/post_product_param.dart';
import '../../../../features/scan_product/domain/params/scan_product_param.dart';
import '../../../data/repositories/scan/scan_repository_impl.dart';

class ScanUseCase {
  final ScanRepository repository;

  ScanUseCase(this.repository);

  Future<ResultCustom<Failure, ProductEntity>> callGetProduct(
    ParamsGetProduct params,
  ) {
    return repository.getProduct(params);
  }

  Future<ResultCustom<Failure, PostItemProductEntity>> callSimpanProduct(
    ParamsPostProduct param,
  ) {
    return repository.simpanProduct(param);
  }
}
