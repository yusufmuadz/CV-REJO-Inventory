import 'package:cv_rejo/features/scan_product/domain/repositories/scan_product_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/item_product_entity.dart';
import '../entities/scan_product_entity.dart';
import '../params/scan_product_param.dart';

class ScanProductUseCase {
  final ScanProductRepository repository;

  ScanProductUseCase(this.repository);

  Future<ResultCustom<Failure, ProductEntity>> call(ParamsGetproduct params) {
    return repository.getProduct(params);
  }

  Future<ResultCustom<Failure, List<ItemProductEntity>>> callGetItem(String search) {
    return repository.getItemProduct(search);
  }
}
