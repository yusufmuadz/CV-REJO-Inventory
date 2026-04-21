import 'package:cv_rejo/features/scan_product/domain/entities/post_item_product_entity.dart';
import 'package:cv_rejo/features/scan_product/domain/repositories/scan_product_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/item_product_entity.dart';
import '../entities/scan_product_entity.dart';
import '../params/post_product_param.dart';
import '../params/scan_product_param.dart';

class ScanProductUseCase {
  final ScanProductRepository repository;

  ScanProductUseCase(this.repository);

  Future<ResultCustom<Failure, ProductEntity>> call(ParamsGetProduct params) {
    return repository.getProduct(params);
  }

  Future<ResultCustom<Failure, List<ItemProductEntity>>> callGetItem(
    String search,
  ) {
    return repository.getItemProduct(search);
  }

  Future<ResultCustom<Failure, PostItemProductEntity>> callPostItem(
    ParamsPostProduct params,
  ) {
    return repository.postItemProduct(params);
  }
}
