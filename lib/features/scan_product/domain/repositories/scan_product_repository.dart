import 'package:cv_rejo/features/scan_product/domain/params/post_product_param.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/item_product_entity.dart';
import '../entities/post_item_product_entity.dart';
import '../entities/scan_product_entity.dart';
import '../params/scan_product_param.dart';

abstract class ScanProductRepository {
  Future<ResultCustom<Failure, ProductEntity>> getProduct(
    ParamsGetProduct params,
  );

  Future<ResultCustom<Failure, List<ItemProductEntity>>> getItemProduct(
    String search,
  );

  Future<ResultCustom<Failure, PostItemProductEntity>> postItemProduct(
    ParamsPostProduct params,
  );
}
