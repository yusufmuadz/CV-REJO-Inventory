import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/multipart_helper.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/detail_order/data/models/response_model_basic.dart';
import '../../../../features/detail_order/data/models/response_model_detail_order.dart';
import '../../../../features/detail_order/domain/params/get_detail_param.dart';
import '../../../../features/ending_order/domain/params/post_ending_order_param.dart';
import '../../../../features/list_order/data/models/response_model_get_transaction_all.dart';
import '../../../../features/list_order/domain/params/get_transaction_param.dart';
import '../../../../features/list_order/domain/params/take_it_param.dart';
import '../../../../features/rit_information/domain/params/post_sorting_sisipan.dart';
import '../../../../features/rit_information/domain/params/trouble_rit_param.dart';
import '../../../../features/rit_information/presentation/controllers/enums/enum_trouble.dart';
import '../../../helpers/api_request_handler.dart';

part 'methods/transaction_get_methods.dart';
part 'methods/transaction_detail_methods.dart';
part 'methods/transaction_end_methods.dart';
part 'methods/transaction_pending_methods.dart';
part 'methods/transaction_armada_methods.dart';
part 'methods/transaction_payment_methods.dart';
part 'methods/transaction_sorting_methods.dart';

// ======== INDUK DATASOURCE ========
abstract class TransactionRemoteDataSource {
  Future<ResponseModelGetTransactionAll> getTransactions(
    ParamsGetTransaction param,
  );
  Future<ResponseModelDetailOrder> getDetailTransactions(ParamsGetDetail param);
  Future<ResponseModelBasic> simpanUrutanTransaction(
    ParamsPostSortingSisipan param,
  );
  Future<ResponseModelBasic> ambilTransactions(ParamsTakeIt param);
  Future<ResponseModelBasic> endTransactions(ParamsEndingOrder param);
  Future<ResponseModelBasic> pendingTransactions(
    ParamsEndingOrder? paramEndingOrder,
    ParamsTroubleRIT? paramTroubleRIT,
  );
  Future<ResponseModelBasic> firstArrive(ParamsEndingOrder paramEndingOrder);
  Future<ResponseModelBasic> imageAllItem(ParamsEndingOrder paramEndingOrder);
  Future<ResponseModelBasic> imageConfirmAllItem(
    ParamsEndingOrder paramEndingOrder,
  );
  Future<ResponseModelBasic> imagePaymentDriver(
    ParamsEndingOrder paramEndingOrder,
  );
  Future<ResponseModelBasic> paymentTransactionCollector(
    ParamsEndingOrder paramEndingOrder,
  );
}

// ======== CHILD DATASOURCE ========
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  TransactionRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET LIST PO/TRANSACTION ============
  @override
  Future<ResponseModelGetTransactionAll> getTransactions(
    ParamsGetTransaction param,
  ) async {
    if (param.isSisipan == true) {
      return _fetchTransactionSisipan(param);
    }

    if (param.pastRit == true) {
      return _fetchPastTransaction(param);
    }

    if (param.isHistory == true) {
      return _fetchHistoryTransaction(param);
    }

    if (AppRole.isChecker2 && param.isTracking == true) {
      return _fetchTransactionTracking(param);
    }

    return _fetchAllTransaction(param);
  }

  // ============ POST SIMPAN URUTKAN PO/TRANSACTION ============
  Future<ResponseModelBasic> simpanUrutanTransaction(
    ParamsPostSortingSisipan param,
  ) {
    return _postSimpanUrutanTransaction(param);
  }

  // ============ GET DETAIL PO/TRANSACTION ============
  @override
  Future<ResponseModelDetailOrder> getDetailTransactions(
    ParamsGetDetail param,
  ) async {
    return _getDetailTransaction(param);
  }

  // ============ AMBIL PO/TRANSACTION ============
  @override
  Future<ResponseModelBasic> ambilTransactions(ParamsTakeIt param) async {
    if (AppRole.isDriver) {
      return _ambilTransactionDriver(param);
    }

    return _ambilTransactionDefault(param);
  }

  // ============ POST ENDING PO/TRANSACTION ============
  @override
  Future<ResponseModelBasic> endTransactions(ParamsEndingOrder param) {
    return _postEndTransaction(param);
  }

  // ============ POST PENDING PO/TRANSACTION ============
  @override
  Future<ResponseModelBasic> pendingTransactions(
    ParamsEndingOrder? paramEndingOrder,
    ParamsTroubleRIT? paramTroubleRIT,
  ) {
    if (AppRole.isDriver && paramTroubleRIT != null) {
      return _postPendingTransactionDriver(paramTroubleRIT);
    }

    return _postPendingTransaction(paramEndingOrder!);
  }

  // ============ POST FIRST ARRIVE ARMADA IN CUSTOMER ============
  @override
  Future<ResponseModelBasic> firstArrive(ParamsEndingOrder paramEndingOrder) {
    return AppRole.isCollector
        ? _postFirstArriveCollector(paramEndingOrder)
        : _postFirstArriveDriver(paramEndingOrder);
  }

  // ============ POST PAYMENT COLLECTOR TRANSACTION IN CUSTOMER ============
  @override
  Future<ResponseModelBasic> paymentTransactionCollector(
    ParamsEndingOrder paramEndingOrder,
  ) {
    return _postPaymentCollector(paramEndingOrder);
  }

  // ============ POST IMAGE ALL ITEM TRANSACTION IN CUSTOMER ============
  @override
  Future<ResponseModelBasic> imageAllItem(ParamsEndingOrder paramEndingOrder) {
    return _postImageAllItem(paramEndingOrder);
  }

  // ============ POST IMAGE KONFIRMASI ALL ITEM TRANSACTION IN CUSTOMER ============
  @override
  Future<ResponseModelBasic> imageConfirmAllItem(
    ParamsEndingOrder paramEndingOrder,
  ) {
    return _postImageConfirmAllItem(paramEndingOrder);
  }

  // ============ POST IMAGE PAYMENT TRANSACTION IN CUSTOMER ============
  @override
  Future<ResponseModelBasic> imagePaymentDriver(
    ParamsEndingOrder paramEndingOrder,
  ) {
    return _postPaymentCustomerDriver(paramEndingOrder);
  }
}
