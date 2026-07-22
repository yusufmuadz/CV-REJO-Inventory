import 'package:cv_rejo/features/ending_order/domain/params/post_ending_order_param.dart';

import '../../../detail_order/data/models/response_model_basic.dart';
import '../../../rit_information/domain/params/trouble_rit_param.dart';
import '../models/response_model_ending_order.dart';

abstract class EndingOrderRemoteDataSource {
  Future<ResponseModelBasic> postEndingOrder(ParamsEndingOrder params);
  Future<ResponseModelBasic> pendingOrder(ParamsEndingOrder params);
  Future<ResponseModelBasic> pendingOrderDriver(ParamsTroubleRIT params);

  // Ending Order Driver
  Future<ResponseModelBasic> firstArriveCustomer(ParamsEndingOrder params);
  Future<ResponseModelBasic> arriveAllItem(ParamsEndingOrder params);
  Future<ResponseModelBasic> arriveImageHandover(ParamsEndingOrder params);
  Future<ResponseModelBasic> arrivePaymentCustomer(ParamsEndingOrder params);
}
