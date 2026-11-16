import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/list_order/domain/entities/rit_list_entity.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../data/repositories/rit/rit_repository_impl.dart';

class RitNewUseCase {
  final RitNewRepository repository;

  RitNewUseCase(this.repository);

  Future<ResultCustom<Failure, List<RitListEntity>>> callRIT({
    required ParamGetRIT param,
  }) {
    return repository.rit(param);
  }
}
