part of '../transaction_repository_impl.dart';

extension TransactionsRepositoryMethods on TransactionRepositoryImpl {
  // ============ MENDAPATAKAN TOTAL PO CHECKER 2 ============
  Future<String> _getTotalPOChecker2() async {
    final storage = GetStorage();

    final response = await ritNewRemoteDataSource.rit(
      ParamGetRIT(
        search: storage.read('city'),
        isPastRit: !(storage.read('isRitToday') ?? false),
        date: storage.read('tanggalRit'),
      ),
    );

    return response.data?.transaction?.firstOrNull?.poPendingCheck2 ?? '-1';
  }

  // ============ POST PAYMENT DRIVER TRANSACTION IN CUSTOMER ============
  Future<ResultCustom<Failure, EndingOrderEntity>>
  _postPaymentTransactionDriver(ParamsEndingOrder params) async {
    try {
      // 1. Proses semua item
      final resultAllItem = await _executeArriveRequest(
        () => dataSource.imageAllItem(params),
      );

      if (resultAllItem is ErrorResult) {
        return ErrorResult(message: (resultAllItem as ErrorResult).message);
      }

      // 2. Upload image handover
      final resultImage = await _executeArriveRequest(
        () => dataSource.imageConfirmAllItem(params),
      );

      if (resultImage is ErrorResult) {
        return ErrorResult(message: (resultImage as ErrorResult).message);
      }

      // 3. Pembayaran jika ada
      if (params.paymentNominal != null) {
        final resultPayment = await _executeArriveRequest(
          () => dataSource.imagePaymentDriver(params),
        );

        if (resultPayment is ErrorResult) {
          return ErrorResult(message: (resultPayment as ErrorResult).message);
        }
      }

      // 4. Semua proses berhasil
      return Success(EndingOrderEntity(totalPO: '0', list: []), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  // ============ EXECUTE ARRIVE REQUEST DRIVER ============
  Future<ResultCustom<Failure, BasicEntity>> _executeArriveRequest(
    Future<ResponseModelBasic> Function() request,
  ) {
    return this.request.execute(
      request: request,
      mapper: (response) {
        return BasicEntity(status: response.status, message: response.message);
      },
      errorMapper: (response) {
        if (response.error == 'Foto sudah diupload.') {
          return '';
        }

        if (response.status == false || response.error != null) {
          return response.error ?? response.message;
        }

        return '';
      },
    );
  }
}
