import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:camera/camera.dart';

import '../../../../shared/images/camera_screen.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../detail_order/data/models/item_order_model.dart';
import '../../domain/params/post_ending_order_param.dart';
import '../../domain/usecases/ending_order_usecase.dart';

class EndingOrderController extends GetxController {
  final EndingOrderUseCase endingOrderUseCase;

  EndingOrderController({required this.endingOrderUseCase});

  final isLoading = false.obs;
  final dialogService = Get.find<DialogService>();
  final noInvoice = ''.obs;
  final rit = ''.obs;
  final dateRit = ''.obs;
  final colorRit = ''.obs;
  final isRitToday = false.obs;

  final statusChecker2 = ''.obs;
  final statatusDriver = ''.obs;

  final fieldController = TextEditingController();

  final mediaFileList = <XFile>[].obs;
  final mediaFileListAllItem = <XFile>[].obs;
  final mediaFileFrontMerchant = <XFile>[].obs;
  final mediaFileListInfoInvoice = <XFile>[].obs;
  final mediaFileListPaymentType = <XFile>[].obs;

  final selectedInfoInvoice = 'Lunas'.obs;
  final infoInvoiceList = ['Lunas', 'Belum Lunas'];

  final selectedPaymentType = 'Tunai'.obs;
  final paymentTypeList = ['Tunai', 'Transfer', 'Giro', 'Cek', 'Debit'];

  final itemPO = <ItemOrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    rit.value = GetStorage().read('city') ?? '';
    dateRit.value = GetStorage().read('tanggalRit') ?? '';
    colorRit.value = GetStorage().read('colorRit') ?? '';
    isRitToday.value = GetStorage().read('isRitToday') ?? false;

    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
      statusChecker2.value = args['status_checker2'] ?? '';
      statatusDriver.value = args['status_driver'] ?? '';
      if (AppRole.isDriver) {
        itemPO.value = args['items'] ?? [];
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = false;
    fieldController.dispose();
    mediaFileList.clear();
    noInvoice.value = '';
  }

  Future<void> saveOrder() async {
    if (isLoading.value) return;

    if (mediaFileList.isEmpty) {
      dialogService.showErrorSnackbar(
        title: 'Gagal!',
        'Masukkan minimal satu foto',
      );
      return;
    }
    isLoading.value = true;

    try {
      final result = await endingOrderUseCase.call(
        ParamsEndingOrder(
          role: AppRole.current!.name.toLowerCase(),
          statusChecker2: statusChecker2.value,
          invoice: noInvoice.value,
          desc: fieldController.text,
          images: mediaFileList,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          dialogService.showDialogBox(
            title: 'Success',
            description: 'Berhasil Menyimpan Pesanan',
            barrierDismissible: false,
            onPressed: () {
              if (AppRole.isChecker2 &&
                  statusChecker2.value != 'completed' &&
                  data.totalPO == '0') {
                GetStorage().write('status_checker2', 'completed');

                ///// ========== KE HALAMAN LIST PESANAN =========== /////
                GetStorage().remove('city');
                GetStorage().remove('colorRit');
                GetStorage().remove('tanggalRit');

                GetStorage().remove('noInvoice');

                Get.offAllNamed(
                  Routes.LIST_ORDER,
                  arguments: {
                    'routeFrom': 'endingOrder',
                    'isRitToday': isRitToday.value,
                  },
                );
              } else {
                GetStorage().remove('noInvoice');
                // GetStorage().remove('status_checker2');

                if (AppRole.isDriver) {
                  Get.offAllNamed(
                    Routes.RIT_INFORMATION,
                    arguments: {
                      'city': rit.value,
                      'colorRit': colorRit.value,
                      'tanggalRit': dateRit.value,
                      'routeFrom': 'endingOrder',
                      'isRitToday': isRitToday.value,
                    },
                  );

                  return;
                }

                ///// ========== KE HALAMAN LIST PESANAN =========== /////

                Get.offAllNamed(
                  Routes.LIST_ORDER,
                  arguments: {
                    'routeFrom': 'endingOrder',
                    'city': rit.value,
                    'tanggalRit': dateRit.value,
                    'colorRit': colorRit.value,
                    'isRitToday': isRitToday.value,
                  },
                );
              }
            },
          );

        case ErrorResult(:final message):
          debugPrint('Error Simpan Pesanan: $message');
          if (Get.isDialogOpen == true) Get.back();
          String pesan = message;

          if (message.contains('Bad state: No element')) {
            pesan =
                'Kemungkinan pesanan sudah disimpan sebelumnya. Silakan cek di history pesanan.';
          }
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', pesan);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pendingProduct() async {
    if (isLoading.value) return;

    if (mediaFileList.isEmpty) {
      dialogService.showErrorSnackbar(
        title: 'Gagal!',
        'Masukkan minimal satu foto',
      );
      return;
    }
    isLoading.value = true;

    try {
      final result = await endingOrderUseCase.callPendingOrder(
        ParamsEndingOrder(
          role: AppRole.current!.name.toLowerCase(),
          statusChecker2: statusChecker2.value,
          invoice: noInvoice.value,
          desc: fieldController.text,
          images: mediaFileList,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          dialogService.showDialogBox(
            title: 'Success',
            description: 'Berhasil Menunda Pesanan',
            barrierDismissible: false,
            onPressed: () {
              GetStorage().remove('noInvoice');
              Get.offAllNamed(
                Routes.LIST_ORDER,
                arguments: {
                  'routeFrom': 'endingOrder',
                  'city': rit.value,
                  'tanggalRit': dateRit.value,
                  'colorRit': colorRit.value,
                  'isRitToday': isRitToday.value,
                },
              );
            },
          );

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
