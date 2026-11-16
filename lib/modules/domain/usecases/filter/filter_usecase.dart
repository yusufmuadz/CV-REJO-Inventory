import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/list_order/domain/entities/district_entity.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../data/repositories/filter/filter_repository_impl.dart';

class FilterUseCase {
  final FilterRepository repository;

  FilterUseCase(this.repository);

  Future<ResultCustom<Failure, List<DistrictEntity>>> callFilterRIT({
    required ParamGetRIT param,
  }) {
    return repository.ritFilter(param);
  }
}
