import 'package:cv_rejo/features/ending_order/domain/params/post_ending_order_param.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../domain/usecases/ending_order_usecase.dart';

class EndingOrderController extends GetxController {
  final EndingOrderUseCase endingOrderUseCase;

  EndingOrderController({required this.endingOrderUseCase});

  final isLoading = false.obs;
  final dialogService = Get.find<DialogService>();
  final noInvoice = ''.obs;

  final fieldController = TextEditingController();

  final picker = ImagePicker();
  final mediaFileList = <XFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
    }
  }

  @override
  void onReady() {
    super.onReady();
    // _getDetailOrder();
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = false;
  }

  Future<void> addProduct({
    required String barcode,
    required String quantity,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await endingOrderUseCase.call(
        ParamsEndingOrder(
          invoice: noInvoice.value,
          desc: fieldController.text,
          images: mediaFileList,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          dialogService.showSuccessSnackbar('Berhasil Menyimpan Produk');

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
