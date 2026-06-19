import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/custom/custom_button.dart';
import '../../controllers/detail_order_controller.dart';
import 'content_input_product_dialog.dart';

Future<bool?> openInputFieldDialog({
  required String itemName,
  required String qty,
  required String barcodeValue,
  required DetailOrderController controller,
}) async {
  await Future.delayed(const Duration(milliseconds: 300));

  final result = await controller.dialogService.inputDialogWithAlertDialog(
    height: 0.5,
    barrierDismissible: false,
    title: 'Informasi Barang',
    titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    actionsPadding: const EdgeInsets.fromLTRB(20, 0.5, 20, 10),
    contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
    insetPadding: const EdgeInsets.symmetric(horizontal: 16),
    content: PopScope(
      canPop: false,
      child: Obx(
        () => ContentInputProductDialog(
          itemName: itemName,
          barcodeValue: barcodeValue,
          mediaFileList: controller.mediaFileList,
          messageProduct: controller.messageProduct.value,
          isLoadingProduct: controller.isLoadingProduct.value,
          qtyController: TextEditingController(text: qty),
        ),
      ),
    ),
    actions: [
      Obx(() {
        String text1 = 'Batal';
        String text2 = 'Tambah';
        Color color1 = Colors.redAccent[100] ?? Colors.red;
        Color color2 = const Color(0xFF2ED471);
        final bool isMessageEmpty = controller.messageProduct.value.isEmpty;
        final bool isVisibleButton2 =
            !controller.isLoadingProduct.value && isMessageEmpty;

        if (!isMessageEmpty) {
          text1 = 'Ulangi';
        }

        return _buildButton(
          title1: text1,
          title2: text2,
          color1: color1,
          color2: color2,
          visible: isVisibleButton2,
          onPressed1: () {
            if (controller.messageProduct.isNotEmpty) {
              controller.messageProduct.value = '';
              return;
            }
            controller.isLoadingProduct.value = false;
            Get.back(result: false);
          },
          onPressed2: () {
            controller.addProduct(barcode: barcodeValue, quantity: qty);
          },
        );
      }),
    ],
  );

  return result;
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
