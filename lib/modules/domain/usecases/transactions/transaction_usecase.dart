import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/detail_order/domain/entities/basic_entity.dart';
import '../../../../features/detail_order/domain/entities/detail_order_entity.dart';
import '../../../../features/detail_order/domain/params/get_detail_param.dart';
import '../../../../features/list_order/domain/entities/list_order_entity.dart';
import '../../../../features/list_order/domain/params/get_transaction_param.dart';
import '../../../../features/list_order/domain/params/take_it_param.dart';
import '../../../../features/rit_information/domain/entities/rit_entity.dart';
import '../../../../features/rit_information/domain/params/post_sorting_sisipan.dart';
import '../../../data/repositories/transactions/transaction_repository_impl.dart';

class TransactionUseCase {
  final TransactionRepository repository;

  TransactionUseCase(this.repository);

  Future<ResultCustom<Failure, List<OrderEntity>>> callGetTransactions({
    required ParamsGetTransaction param,
  }) {
    return repository.getTransactions(param);
  }

  Future<ResultCustom<Failure, RitEntity>> callSimpanUrutanTransaction({
    required ParamsPostSortingSisipan param,
  }) {
    return repository.simpanUrutanTransaction(param);
  }

  Future<ResultCustom<Failure, DetailOrderEntity>> callGetDetailTransactions({
    required ParamsGetDetail param,
  }) {
    return repository.getDetailTransactions(param);
  }

  Future<ResultCustom<Failure, BasicEntity>> callAmbilTransactions({
    required ParamsTakeIt param,
  }) {
    return repository.ambilTransactions(param);
  }
}
