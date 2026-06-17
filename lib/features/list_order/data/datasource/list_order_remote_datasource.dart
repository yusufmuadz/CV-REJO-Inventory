import 'package:cv_rejo/features/list_order/domain/params/take_it_param.dart';

import '../../../detail_order/data/models/response_model_basic.dart';
import '../../../detail_order/data/models/response_model_get_transporation.dart';
import '../../../detail_order/data/models/response_model_get_user.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
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

  Future<ResponseModelGetDistrict> getDistrict();
  Future<ResponseModelGetRit> getRit(ParamGetRIT param);

  Future<ResponseModelGetUser> getUsers();
  Future<ResponseModelGetTransportation> getTransportations();
  Future<ResponseModelGetTransportation> getLoaderTransportations();
  Future<ResponseModelBasic> addAssistant(ParamsAddAssistant params);
}
