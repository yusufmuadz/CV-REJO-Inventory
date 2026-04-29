import '../../../scan_product/data/models/response_model_post_item_product.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../../domain/params/add_assistant_param.dart';
import '../../domain/params/pending_so_param.dart';
import '../models/response_model_basic.dart';
import '../models/response_model_detail_order.dart';
import '../models/response_model_get_transporation.dart';
import '../models/response_model_get_user.dart';

abstract class DetailOrderRemoteDataSource {
  Future<ResponseModelDetailOrder> fetchTransaction(String noInvoice);

  Future<ResponseModelGetUser> getUsers();
  Future<ResponseModelGetTransportation> getTransportations();
  Future<ResponseModelGetTransportation> getLoaderTransportations();
  Future<ResponseModelBasic> addAssistant(ParamsAddAssistant params);
  Future<ResponseModelBasic> pendingSO(ParamsPendingSO params);
  Future<ResponseModelPostItemProduct> postItemProduct(
    ParamsPostProduct params,
  );
}
