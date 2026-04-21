import 'package:cv_rejo/features/scan_product/domain/params/post_product_param.dart';

import '../../domain/params/scan_product_param.dart';
import '../models/response_model_get_item_product.dart';
import '../models/response_model_post_item_product.dart';
import '../models/response_model_scan_product.dart';

abstract class ScanProductRemoteDataSource {
  Future<ResponseModelScanProduct> getProduct(ParamsGetProduct params);
  Future<ResponseModelGetItemProduct> getItemProduct(String search);
  Future<ResponseModelPostItemProduct> postItemProduct(ParamsPostProduct params);
}
