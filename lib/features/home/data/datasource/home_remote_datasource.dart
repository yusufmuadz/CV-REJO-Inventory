import '../../../list_order/data/models/response_model_get_transaction_all.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../../list_order/data/models/response_model_get_transaction.dart';
import '../models/response_model_get_home.dart';

abstract class HomeRemoteDataSource {
  Future<ResponseModelGetTransactionAll> fetchTransaction(
    ParamsGetTransaction params,
  );
  Future<ResponseModelGetHome> getHomeData();
}
