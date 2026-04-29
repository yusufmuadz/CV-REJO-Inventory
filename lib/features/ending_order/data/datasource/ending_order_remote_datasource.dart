import 'package:cv_rejo/features/ending_order/domain/params/post_ending_order_param.dart';

import '../models/response_model_ending_order.dart';

abstract class EndingOrderRemoteDataSource {
  Future<ResponseModelEndingOrder> postEndingOrder(ParamsEndingOrder params);
  Future<ResponseModelEndingOrder> pendingOrder(ParamsEndingOrder params);
}
