import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/rit_entity.dart';
import '../params/post_rit_param.dart';

abstract class RitRepository {
  Future<ResultCustom<Failure, RitEntity>> postEndingOrder(
    ParamsRit params,
  );
  Future<ResultCustom<Failure, RitEntity>> pendingOrder(
    ParamsRit params,
  );
}
