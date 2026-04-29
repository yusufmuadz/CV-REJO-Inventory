import '../../../list_order/data/models/response_model_get_district.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../models/response_model_get_history_order.dart';

abstract class ListHistoryOrderRemoteDataSource {
  Future<ResponseModelHistoryOrderAll> fetchTransaction(
    ParamsGetTransaction params,
  );
  Future<ResponseModelGetDistrict> getDistrict();
}
