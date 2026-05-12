import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/rit_entity.dart';
import '../params/post_rit_param.dart';
import '../repositories/rit_repository.dart';

class RitUseCase {
  final RitRepository repository;

  RitUseCase(this.repository);

  Future<ResultCustom<Failure, RitEntity>> call(
    ParamsRit params,
  ) {
    return repository.postEndingOrder(params);
  }

  Future<ResultCustom<Failure, RitEntity>> callPendingOrder(
    ParamsRit params,
  ) {
    return repository.pendingOrder(params);
  }
}
