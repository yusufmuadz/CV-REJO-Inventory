import 'package:cv_rejo/features/list_order/domain/params/take_it_param.dart';

import '../../domain/params/get_rit_param.dart';
import '../../domain/params/get_transaction_param.dart';
import '../models/response_model_get_district.dart';
import '../models/response_model_get_rit.dart';
import '../models/response_model_get_transaction_all.dart';
import '../models/response_model_take_it_transaction.dart';

abstract class ListOrderRemoteDataSource {
  Future<ResponseModelGetTransactionAll> fetchTransaction(
    ParamsGetTransaction params,
  );

  Future<ResponseModelTakeItTransaction> takeItTransaction(ParamsTakeIt params);
  Future<ResponseModelGetDistrict> getDistrict();
  Future<ResponseModelGetRit> getRit(ParamGetRIT param);
}
