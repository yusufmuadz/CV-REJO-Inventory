import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../domain/entities/detail_order_entity.dart';
import '../../domain/usecases/detail_order_usecase.dart';
import 'detail_order_controller.dart';

class GetDetailOrderController extends GetxController {
  final DetailOrderUseCase detailOrderUseCase;

  GetDetailOrderController({required this.detailOrderUseCase});

  DetailOrderController get masterCtrlr => Get.find<DetailOrderController>();

  Future<void> getDetailOrder() async {
    if (masterCtrlr.isLoading.value) return;
    masterCtrlr.isLoading.value = true;

    try {
      final result = await detailOrderUseCase.call('01SL20200500011');
      // final result = await detailOrderUseCase.call(masterCtrlr.noInvoice.value);

      switch (result) {
        case Success(:final data):
          _successGetDetailOrder(data: data);
        case ErrorResult(:final message):
          _errorGetDetailOrder(message: message);
      }
    } catch (e) {
      _errorGetDetailOrder(message: e.toString());
    } finally {
      masterCtrlr.isLoading.value = false;
    }
  }

  //////////==================== FUNCTION DETAIL ORDER ====================//////////

  void _successGetDetailOrder({required DetailOrderEntity data}) {
    masterCtrlr.orderDetail.value = data;

    final list = data.orderDetails ?? [];

    if (AppRole.isDriver && list.isNotEmpty) {
      final finishCheckFirstItem = list.firstOrNull?.statusFinishScan ?? false;
      if (finishCheckFirstItem) {
        masterCtrlr.statusDriver.value = 'completed';
      }
    }

    masterCtrlr.driverSelected.value = data.assistant?.namaDriver ?? '';
    masterCtrlr.assistantSelected.value = data.assistant?.namaKenek ?? '';
    masterCtrlr.selectTransportation.value =
        data.assistant?.namaKendaraan ?? '';

    if (!AppRole.isDriver) {
      bool check =
          data.assistant!.namaDriver != '-' &&
          data.assistant!.namaDriver != '-' &&
          data.assistant!.namaKendaraan != '-';

      if (AppRole.isChecker2) {
        check =
            data.driver!.namaDriver != '-' &&
            data.driver!.namaDriver != '-' &&
            data.driver!.namaKendaraan != '-';
        masterCtrlr.driverSelected.value = data.driver?.namaDriver ?? '';
        masterCtrlr.assistantSelected.value = data.driver?.namaKenek ?? '';
        masterCtrlr.selectTransportation.value =
            data.driver?.namaKendaraan ?? '';
        masterCtrlr.nopolTransportation.value = data.driver?.idKendaraan ?? '';
      }

      // debugPrint('Check Assistant: $check');
      // debugPrint('Check Driver: ${data.assistant?.namaDriver}');
      // debugPrint('Check Nama Kenek: ${data.assistant?.namaKenek}');
      // debugPrint('Check Nama Kendaraan: ${data.assistant?.namaKendaraan}');

      masterCtrlr.isSelect.value = check;
    }
  }

  void _errorGetDetailOrder({required String message}) {
    if (Get.isDialogOpen == true) Get.back();
    // masterCtrlr.loadState.value = LoadState.error;
    masterCtrlr.dialogService.showError('Failed', message);
  }
}
