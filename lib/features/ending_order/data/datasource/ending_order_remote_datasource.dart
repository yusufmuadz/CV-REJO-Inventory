import 'package:cv_rejo/features/ending_order/domain/params/post_ending_order_param.dart';

import '../../../rit_information/domain/params/trouble_rit_param.dart';
import '../models/response_model_ending_order.dart';

abstract class EndingOrderRemoteDataSource {
  Future<ResponseModelEndingOrder> postEndingOrder(ParamsEndingOrder params);
  Future<ResponseModelEndingOrder> pendingOrder(ParamsEndingOrder params);
  Future<ResponseModelEndingOrder> pendingOrderDriver(ParamsTroubleRIT params);

  // Ending Order Driver
  Future<ResponseModelEndingOrder> firstArriveCustomer(ParamsEndingOrder params);
  Future<ResponseModelEndingOrder> arriveAllItem(ParamsEndingOrder params);
  Future<ResponseModelEndingOrder> arriveImageHandover(ParamsEndingOrder params);
  Future<ResponseModelEndingOrder> arrivePaymentCustomer(ParamsEndingOrder params);
}
