import '../../../list_order/domain/params/take_it_param.dart';
import '../../../scan_product/data/models/response_model_post_item_product.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../../domain/params/add_assistant_param.dart';
import '../../domain/params/get_detail_param.dart';
import '../../domain/params/pending_so_param.dart';
import '../models/response_model_basic.dart';
import '../models/response_model_detail_order.dart';

abstract class DetailOrderRemoteDataSource {
  Future<ResponseModelDetailOrder> fetchTransaction(ParamsGetDetail params);

  Future<ResponseModelBasic> pendingSO(ParamsPendingSO params);
  Future<ResponseModelPostItemProduct> postItemProduct(
    ParamsPostProduct params,
  );
  Future<ResponseModelBasic> takeItTransactionDriver(ParamsAddAssistant params);
  Future<ResponseModelBasic> takeItTransaction(ParamsTakeIt params);
}
