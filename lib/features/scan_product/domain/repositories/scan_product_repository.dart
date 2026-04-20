import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/item_product_entity.dart';
import '../entities/scan_product_entity.dart';
import '../params/scan_product_param.dart';

abstract class ScanProductRepository {
  Future<ResultCustom<Failure, ProductEntity>> getProduct(
    ParamsGetproduct params,
  );

  Future<ResultCustom<Failure, List<ItemProductEntity>>> getItemProduct(
    String search,
  );
}
