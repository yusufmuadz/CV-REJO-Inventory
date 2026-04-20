import '../../domain/params/get_transaction_param.dart';
import '../models/response_model_get_transaction_all.dart';
import '../models/response_model_take_it_transaction.dart';

abstract class ListOrderRemoteDataSource {
  Future<ResponseModelGetTransactionAll> fetchTransaction(
    ParamsGetTransaction params,
  );

  Future<ResponseModelTakeItTransaction> takeItTransaction(String invoice);
}
