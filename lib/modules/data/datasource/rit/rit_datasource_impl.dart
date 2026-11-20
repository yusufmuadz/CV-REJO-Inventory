import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/detail_order/data/models/response_model_basic.dart';
import '../../../../features/detail_order/domain/params/add_assistant_param.dart';
import '../../../../features/list_order/data/models/response_model_get_rit.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../helpers/api_request_handler.dart';

part 'methods/rit_get_methods.dart';
part 'methods/rit_ambil_methods.dart';

// ======== INDUK DATASOURCE ========
abstract class RitNewRemoteDataSource {
  Future<ResponseModelGetRit> rit(ParamGetRIT param);
  Future<ResponseModelBasic> ambilRit(ParamsAddAssistant param);
}

// ======== CHILD DATASOURCE ========
class RitNewRemoteDataSourceImpl implements RitNewRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  RitNewRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET LIST RIT TODAY/PAST/SISIPAN ============
  @override
  Future<ResponseModelGetRit> rit(ParamGetRIT param) {
    if (param.isSisipan == true) {
      return _ritSisipan(param);
    }

    if (param.isPastRit == true) {
      return _ritPast(param);
    }

    return _ritToday(param);
  }

  // ============ POST AMBIL RIT TODAY/PAST/SISIPAN ============
  @override
  Future<ResponseModelBasic> ambilRit(ParamsAddAssistant param) {
    final isChecker2 = AppRole.isChecker2;
    final isDetail = param.isDetail == true;
    final isSisipan = param.isSisipan == true;

    final urlRole = param.isChecker2 == true
        ? 'check2'
        : AppRole.current?.name.toLowerCase() ?? 'picking';

    final data = _buildAssistantData(
      param,
      isChecker2: isChecker2,
      isDetail: isDetail,
    );

    if (!isDetail && !isSisipan) {
      return _takeItRIT(urlRole, data);
    }

    return _submitAssistant(
      isSisipan
          ? ApiEndpoints.addAssistantSisipan
          : ApiEndpoints.changeTransportation,
      data,
    );
  }
}
