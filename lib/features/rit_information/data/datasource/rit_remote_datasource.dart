
import '../../../list_order/data/models/response_model_get_transaction_all.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/params/post_rit_param.dart';
import '../models/response_model_rit.dart';

abstract class RitRemoteDataSource {
  Future<ResponseModelRit> postEndingOrder(ParamsRit params);
  Future<ResponseModelRit> pendingOrder(ParamsRit params);
  Future<ResponseModelGetTransactionAll> getOrders(
    ParamsGetTransaction params,
  );
}
