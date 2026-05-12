
import '../../domain/params/post_rit_param.dart';
import '../models/response_model_rit.dart';

abstract class RitRemoteDataSource {
  Future<ResponseModelRit> postEndingOrder(ParamsRit params);
  Future<ResponseModelRit> pendingOrder(ParamsRit params);
}
