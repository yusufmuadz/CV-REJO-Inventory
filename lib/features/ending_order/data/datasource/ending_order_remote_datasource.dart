import '../models/response_model_ending_order.dart';

abstract class EndingOrderRemoteDataSource {
  Future<ResponseModelEndingOrder> fetchTransaction(String noInvoice);
}
