import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../shared/images/camera_screen.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../../data/models/item_order_model.dart';
import '../../domain/usecases/detail_order_usecase.dart';
import 'detail_order_controller.dart';

class AddProductOrderController extends GetxController {
  final DetailOrderUseCase detailOrderUseCase;

  AddProductOrderController({required this.detailOrderUseCase});

  DetailOrderController get masterCtrlr => Get.find<DetailOrderController>();

  void addImageInAllProduct({required int index}) async {
    try {
      // String? path = await cameraService.takePicture();
      final String? path = await Get.to(() => const CameraScreen());

      if (index >= 0 && path != null) {
        final order = masterCtrlr.orderDetail.value.orderDetails![index];

        RxList<XFile> files = RxList<XFile>.from(order.mediaFileList ?? []);

        files.add(XFile(path));

        final updatedOrder = order.copyWith(mediaFileList: files);

        final updateList = List<ItemOrderModel>.from(
          masterCtrlr.orderDetail.value.orderDetails!,
        );
        updateList[index] = updatedOrder;

        masterCtrlr.orderDetail.value = masterCtrlr.orderDetail.value.copyWith(
          orderDetails: updateList,
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      masterCtrlr.dialogService.showErrorSnackbar('Gagal menambah gambar\n$e');
    }
  }

  void removeImageInAllProduct({
    required int indexOrder,
    required int indexImage,
    required RxList<XFile> files,
  }) {
    try {
      masterCtrlr.orderDetail.value.orderDetails![indexOrder].mediaFileList
          ?.removeAt(indexImage);
      masterCtrlr.orderDetail.refresh();
    } catch (e) {
      debugPrint('Error remove image: $e');
      masterCtrlr.dialogService.showErrorSnackbar('Gagal menghapus gambar\n$e');
    }
  }

  //////////==================== FUNCTION ADD DETAIL ORDER ====================//////////

  Future<void> addProduct({
    required String barcode,
    required String quantity,
    required RxList<XFile> mediaFileList,
  }) async {
    if (masterCtrlr.isLoadingProduct.value) return;

    if (mediaFileList.isEmpty) {
      return;
    }

    masterCtrlr.isLoadingProduct.value = true;

    try {
      final result = await detailOrderUseCase.callPostItem(
        ParamsPostProduct(
          role: AppRole.current!.name.toLowerCase(),
          barcode: barcode,
          invoice: masterCtrlr.noInvoice.value,
          qty: quantity,
          statusChecker2: masterCtrlr.statusChecker2.value,
          images: mediaFileList,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          Get.back(result: true); // Tutup dialog
          masterCtrlr.dialogService.showSuccessSnackbar(
            'Berhasil Menambahkan Produk',
          );

        case ErrorResult(:final message):
          // masterCtrlr.loadState.value = LoadState.error;
          masterCtrlr.messageProduct.value = message;
          masterCtrlr.statusPostProduct.value = false;
      }
    } finally {
      masterCtrlr.isLoadingProduct.value = false;
    }
  }

  Future<void> addAllProducts() async {
    final orders = masterCtrlr.orderDetail.value.orderDetails;
    if (orders == null || orders.isEmpty) return;

    // Filter hanya yang punya gambar
    final ordersWithImages = orders
        .where(
          (elmnt) =>
              elmnt.mediaFileList != null && elmnt.mediaFileList!.isNotEmpty,
        )
        .toList();

    if (ordersWithImages.isEmpty) {
      masterCtrlr.dialogService.showErrorSnackbar(
        'Tidak ada gambar untuk diupload',
      );
      return;
    }

    try {
      for (var i = 0; i < ordersWithImages.length; i++) {
        final order = ordersWithImages[i];

        // Set loading untuk item ini
        order.isLoading = true;
        masterCtrlr.orderDetail.refresh();

        try {
          final result = await detailOrderUseCase.callPostItem(
            ParamsPostProduct(
              role: AppRole.current!.name.toLowerCase(),
              barcode: order.barcode, // Ambil dari model
              invoice: masterCtrlr.noInvoice.value,
              qty: order.qty.toString(), // Ambil dari model
              statusChecker2: masterCtrlr.statusChecker2.value,
              images: order.mediaFileList!, // Ambil dari model
            ),
          );

          switch (result) {
            case Success(:final data):
              debugPrint('Data Item Product ${i + 1}: $data');
              order.isChecked = true;
              order.isLoading = false;

            case ErrorResult(:final message):
              order.isChecked = false;
              order.isLoading = false;
              order.hasError = true;
              debugPrint('Error item ${i + 1}: $message');
          }
        } catch (e) {
          order.isLoading = false;
          order.hasError = true;
          debugPrint('Exception item ${i + 1}: $e');
        }

        // Refresh UI setelah setiap item selesai
        masterCtrlr.orderDetail.refresh();
      }

      // Tampilkan snackbar hasil akhir
      final successCount = ordersWithImages
          .where((o) => o.isChecked == true)
          .length;
      masterCtrlr.dialogService.showSuccessSnackbar(
        'Berhasil upload $successCount dari ${ordersWithImages.length} produk',
      );
    } catch (e) {
      debugPrint('Error in addAllProducts: $e');
      masterCtrlr.dialogService.showErrorSnackbar(
        'Terjadi kesalahan saat upload',
      );
    }
  }
}
