import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../domain/params/post_ending_order_param.dart';
import '../../domain/usecases/ending_order_usecase.dart';

class EndingOrderController extends GetxController {
  final EndingOrderUseCase endingOrderUseCase;

  EndingOrderController({required this.endingOrderUseCase});

  final isLoading = false.obs;
  final dialogService = Get.find<DialogService>();
  final noInvoice = ''.obs;
  final rit = ''.obs;
  final colorRit = ''.obs;

  final statusChecker2 = ''.obs;

  final fieldController = TextEditingController();

  final picker = ImagePicker();
  final mediaFileList = <XFile>[].obs;

  final selectedInfoInvoice = 'Lunas'.obs;
  final infoInvoiceList = ['Lunas', 'Belum Lunas'];

  final selectedPaymentType = 'Tunai'.obs;
  final paymentTypeList = ['Tunai', 'Transfer', 'Giro', 'Cek', 'Debit'];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    rit.value = GetStorage().read('city') ?? '';
    colorRit.value = GetStorage().read('colorRit') ?? '';
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
      statusChecker2.value = args['status_checker2'] ?? '';
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
          // debugPrint('Status: ${statusChecker2.value}');
          dialogService.showDialogBox(
            title: 'Success',
            description: 'Berhasil Menyimpan Pesanan',
            barrierDismissible: false,
            onPressed: () {
              if (AppRole.isChecker2 &&
                  (statusChecker2.value == 'available' ||
                      statusChecker2.value == 'ongoing')) {
                GetStorage().write('status_checker2', 'completed');
                Get.offAllNamed(
                  Routes.DETAIL_ORDER,
                  arguments: {
                    'routeFrom': 'listOrder',
                    'take_it_order': true,
                    'status_checker2': 'completed',
                    'invoice': noInvoice.value,
                  },
                );
              } else {
                debugPrint('Data TOTAL PO: ${data.totalPO}');
                if (data.totalPO != null && data.totalPO == '0') {
                  GetStorage().remove('city');
                }
                GetStorage().remove('noInvoice');
                GetStorage().remove('status_checker2');
                Get.offAllNamed(
                  Routes.LIST_ORDER,
                  arguments: {
                    'routeFrom': 'endingOrder',
                    'city': rit.value,
                    'colorRit': colorRit.value,
                  },
                );
              }
            },
          );

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
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
                arguments: {'routeFrom': 'endingOrder'},
              );
            },
          );

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source, // Atau ImageSource.gallery untuk galeri
        imageQuality: 70,
      );

      if (pickedFile != null) {
        mediaFileList.add(pickedFile);
        update(); // Memperbarui state untuk menampilkan gambar yang dipilih
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < mediaFileList.length) {
      mediaFileList.removeAt(index);
      update(); // Memperbarui state setelah gambar dihapus
    }
  }

  void clearAllImages() {
    mediaFileList.clear();
    update(); // Memperbarui state setelah semua gambar dan teks dihapus
  }
}
