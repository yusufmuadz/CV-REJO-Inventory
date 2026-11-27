import 'package:get_storage/get_storage.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/detail_order/data/models/response_model_basic.dart';
import '../../../../features/detail_order/domain/entities/basic_entity.dart';
import '../../../../features/detail_order/domain/entities/detail_order_entity.dart';
import '../../../../features/detail_order/domain/params/get_detail_param.dart';
import '../../../../features/ending_order/domain/entities/ending_order_entity.dart';
import '../../../../features/ending_order/domain/params/post_ending_order_param.dart';
import '../../../../features/list_order/domain/entities/list_order_entity.dart';
import '../../../../features/list_order/domain/params/get_rit_param.dart';
import '../../../../features/list_order/domain/params/get_transaction_param.dart';
import '../../../../features/list_order/domain/params/take_it_param.dart';
import '../../../../features/rit_information/domain/entities/rit_entity.dart';
import '../../../../features/rit_information/domain/params/post_sorting_sisipan.dart';
import '../../../../features/rit_information/domain/params/trouble_rit_param.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/rit/rit_datasource_impl.dart';
import '../../datasource/transaction/transaction_datasource_impl.dart';

part 'methods/transactions_repository_methods.dart';

// ============ INDUK REPOSITORY ============
abstract class TransactionRepository {
  Future<ResultCustom<Failure, List<OrderEntity>>> getTransactions(
    ParamsGetTransaction param,
  );
  Future<ResultCustom<Failure, RitEntity>> simpanUrutanTransaction(
    ParamsPostSortingSisipan param,
  );
  Future<ResultCustom<Failure, DetailOrderEntity>> getDetailTransactions(
    ParamsGetDetail param,
  );
  Future<ResultCustom<Failure, BasicEntity>> ambilTransactions(
    ParamsTakeIt param,
  );
  Future<ResultCustom<Failure, EndingOrderEntity>> endTransactions(
    ParamsEndingOrder param,
  );
  Future<ResultCustom<Failure, EndingOrderEntity>> pendingTransactions(
    ParamsEndingOrder? paramEndingOrder,
    ParamsTroubleRIT? paramTroubleRIT,
  );
  Future<ResultCustom<Failure, EndingOrderEntity>> firstArriveInCustomer(
    ParamsEndingOrder paramEndingOrder,
  );
  Future<ResultCustom<Failure, EndingOrderEntity>> paymentTransactionDriver(
    ParamsEndingOrder paramEndingOrder,
  );

  Future<ResultCustom<Failure, EndingOrderEntity>> paymentTransactionCollector(
    ParamsEndingOrder paramEndingOrder,
  );
}

// ============ CHILD REPOSITORY ============
class TransactionRepositoryImpl implements TransactionRepository {
  RitNewRemoteDataSource ritNewRemoteDataSource;
  TransactionRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  TransactionRepositoryImpl(
    this.ritNewRemoteDataSource,
    this.dataSource,
    this.request,
  );

  // ============ GET LIST PO/TRANSACTION TODAY/PAST/SISIPAN/HISTORY/TRACKING ============
  @override
  Future<ResultCustom<Failure, List<OrderEntity>>> getTransactions(
    ParamsGetTransaction param,
  ) async {
    return request.execute(
      request: () => dataSource.getTransactions(param),
      mapper: (response) => response.data!.toEntity(),
    );
  }

  // ============ GET LIST PO/TRANSACTION TODAY/PAST/SISIPAN/HISTORY/TRACKING ============
  @override
  Future<ResultCustom<Failure, RitEntity>> simpanUrutanTransaction(
    ParamsPostSortingSisipan param,
  ) async {
    return request.execute(
      request: () => dataSource.simpanUrutanTransaction(param),
      mapper: (response) => RitEntity(list: []),
    );
  }

  // ============ GET DETAIL PO/TRANSACTION ============
  @override
  Future<ResultCustom<Failure, DetailOrderEntity>> getDetailTransactions(
    ParamsGetDetail param,
  ) async {
    return request.execute(
      request: () => dataSource.getDetailTransactions(param),
      mapper: (response) => response.data!.toEntity(),
    );
  }

  // ============ AMBIL PO/TRANSACTION ============
  @override
  Future<ResultCustom<Failure, BasicEntity>> ambilTransactions(
    ParamsTakeIt param,
  ) async {
    return request.execute(
      request: () => dataSource.ambilTransactions(param),
      mapper: (response) {
        return BasicEntity(status: response.status, message: response.message);
      },
    );
  }

  // ============ POST ENDING PO/TRANSACTION ============
  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> endTransactions(
    ParamsEndingOrder params,
  ) async {
    final result = await request.execute(
      request: () => dataSource.endTransactions(params),
      mapper: (response) {
        return EndingOrderEntity(totalPO: '-1', list: []);
      },
    );

    if (result is ErrorResult) return result;

    final entity = (result as Success).data;

    if (AppRole.isChecker2 && params.statusChecker2 != 'completed') {
      final totalPO = await _getTotalPOChecker2();

      return Success(
        EndingOrderEntity(totalPO: totalPO, list: entity.list),
        '',
      );
    }

    return result;
  }

  // ============ POST PENDING PO/TRANSACTION ============
  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> pendingTransactions(
    ParamsEndingOrder? paramEndingOrder,
    ParamsTroubleRIT? paramTroubleRIT,
  ) async {
    return request.execute(
      request: () {
        return dataSource.pendingTransactions(
          paramEndingOrder,
          paramTroubleRIT,
        );
      },
      mapper: (response) => EndingOrderEntity(list: []),
    );
  }

  // ============ POST FIRST ARRIVE PO/TRANSACTION IN CUSTOMER ============
  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> firstArriveInCustomer(
    ParamsEndingOrder paramEndingOrder,
  ) async {
    return request.execute(
      request: () {
        return dataSource.firstArrive(paramEndingOrder);
      },
      mapper: (response) => EndingOrderEntity(list: []),
    );
  }

  // ============ POST PAYMENT DRIVER TRANSACTION IN CUSTOMER ============
  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> paymentTransactionDriver(
    ParamsEndingOrder params,
  ) async {
    return _postPaymentTransactionDriver(params);
  }

  // ============ POST PAYMENT COLLECTOR PO/TRANSACTION IN CUSTOMER ============
  @override
  Future<ResultCustom<Failure, EndingOrderEntity>> paymentTransactionCollector(
    ParamsEndingOrder paramEndingOrder,
  ) async {
    return request.execute(
      request: () {
        return dataSource.paymentTransactionCollector(paramEndingOrder);
      },
      mapper: (response) => EndingOrderEntity(),
    );
  }
}
