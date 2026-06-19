import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../shared/custom/custom_button.dart';
import '../../../../detail_order/presentation/widgets/dialog/content_input_product_dialog.dart';
import '../../controllers/scan_product_controller.dart';

Future<void> openInputQtyDialog({
  required String itemName,
  required String barcodeValue,
  required ScanProductController controller,
}) async {
  await Future.delayed(const Duration(milliseconds: 300));

  final qtyController = TextEditingController();
  controller.mediaFileList.clear();

  controller.dialogService.defaultDialog(
    height: 0.35,
    title: 'Masukkan Jumlah Barang',
    titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    actionsPadding: const EdgeInsets.fromLTRB(20, 0.5, 20, 10),
    contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
    content: PopScope(
      canPop: false,
      child: Obx(
        () => ContentInputProductDialog(
          isInputQty: true,
          itemName: itemName,
          barcodeValue: barcodeValue,
          mediaFileList: controller.mediaFileList,
          messageProduct: controller.messageProduct.value,
          isLoadingProduct: controller.isLoadingProduct.value,
          qtyController: qtyController,
        ),
      ),
    ),
    actions: [
      Obx(() {
        String text1 = 'Batal';
        String text2 = 'Tambah';
        Color color1 = Colors.redAccent[100] ?? Colors.red;
        Color color2 = const Color(0xFF2ED471);

        if (controller.messageProduct.isNotEmpty) {
          if (!controller.statusPostProduct.value) {
            text1 = 'Ulangi';
          } else {
            text1 = 'Kembali';
          }
        }

        if (AppRole.isChecker1 && controller.isMaxFailureChecker.value) {
          text1 = 'Kembali';
          text2 = 'Hubungi Admin';
          color1 = Colors.red;
          color2 = const Color(0xFF0c8ce8);
        }

        return _buildButton(
          title1: text1,
          title2: text2,
          color1: color1,
          color2: color2,
          visible:
              !controller.isLoadingProduct.value &&
              (controller.messageProduct.isEmpty ||
                  controller.isMaxFailureChecker.value),
          onPressed1: () {
            if (controller.isMaxFailureChecker.value) {
              ///// ========== KE HALAMAN LIST PESANAN =========== /////

              final rit = GetStorage().read('city') ?? '';
              final colorRit = GetStorage().read('colorRit') ?? '';
              final tanggalRit = GetStorage().read('tanggalRit') ?? '';
              final isRitToday = GetStorage().read('isRitToday') ?? false;

              Get.toNamed(
                Routes.LIST_ORDER,
                arguments: {
                  'routeFrom': 'home',
                  'city': rit,
                  'colorRit': colorRit,
                  'tanggalRit': tanggalRit,
                  'isRitToday': isRitToday,
                },
              );
              return;
            }
            if (!controller.statusPostProduct.value &&
                controller.messageProduct.isNotEmpty) {
              controller.messageProduct.value = '';
              return;
            }

            Get.back(); // Tutup dialog
            qtyController.clear();
            controller.mediaFileList.clear();
            controller.messageProduct.value = '';
            controller.startScanner(); // Mulai ulang pemindaian
          },
          onPressed2: () {
            if (controller.isMaxFailureChecker.value) {
              controller.onTapHubungiAdmin();
              return;
            }

            if (qtyController.text.isEmpty &&
                controller.mediaFileList.isEmpty) {
              return;
            }

            controller.addProduct(
              barcode: barcodeValue,
              quantity: qtyController.text,
            );
          },
        );
      }),
    ],
  );
}

Widget _buildButton({
  required String title1,
  required String? title2,
  required Color color1,
  required Color? color2,
  bool visible = false,
  VoidCallback? onPressed1,
  VoidCallback? onPressed2,
}) {
  return CustomButton.doubleButton(
    title1: title1,
    title2: title2!,
    color1: color1,
    color2: color2!,
    onPressed1: onPressed1 ?? () => Get.back(),
    onPressed2: onPressed2 ?? () => Get.back(),
    visible2: visible,
    visibleSpace: visible,
  );
}
