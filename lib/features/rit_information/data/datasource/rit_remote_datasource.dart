import '../../../detail_order/data/models/response_model_basic.dart';
import '../../../list_order/data/models/response_model_get_transaction_all.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/params/trouble_rit_param.dart';
import '../../domain/params/post_rit_param.dart';

abstract class RitRemoteDataSource {
  Future<ResponseModelBasic> postSaveDataDriver(ParamsRit params);
  Future<ResponseModelBasic> postCancelRIT(ParamsTroubleRIT params);
  Future<ResponseModelGetTransactionAll> getOrders(ParamsGetTransaction params);
  // Future<ResponseModelBasic> postArriveOfficeDriver(ParamsRit params);
}
