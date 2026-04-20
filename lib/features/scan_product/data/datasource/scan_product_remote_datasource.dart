import '../../domain/params/scan_product_param.dart';
import '../models/response_model_get_item_product.dart';
import '../models/response_model_scan_product.dart';

abstract class ScanProductRemoteDataSource {
  Future<ResponseModelScanProduct> getProduct(ParamsGetproduct params);
  Future<ResponseModelGetItemProduct> getItemProduct(String search);
}
