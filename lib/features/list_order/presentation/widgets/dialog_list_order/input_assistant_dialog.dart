import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../utils/loading_custom.dart';
import '../../../../detail_order/presentation/widgets/dialog/input_assisten_widget.dart';
import '../../controllers/list_order_controller.dart';

class InputAssistantDialog {
  static Future<bool> inputAsisten(
    ListOrderController controller, {
    bool isDetail = false,
    String invoice = '',
  }) async {
    final bool result =
        await controller.dialogService.inputDialog(
          height: 0.6,
          title: 'Masukkan ${AppRole.isChecker2 ? 'Muat Barang' : 'Asisten'}',
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          onPressed1: () {
            if (controller.isLoadingAssistant.value) return;

            Get.back(result: false);
          },
          onPressed2: () async {
            if (controller.isLoadingAssistant.value) return;

            final resultAdd = await controller.postDataListController
                .addAssistant(isDetail: isDetail, invoice: invoice);

            if (!resultAdd) return;
            Get.back(result: resultAdd);
            controller.dialogService.showSuccessSnackbar(
              'Berhasil Menambahkan Asisten',
            );
          },
          content: Obx(() {
            if (controller.isLoadingAssistant.value) {
              return SizedBox(width: Get.width, child: const LoadingView());
            }

            return InputAssistenWidget(
              controller: controller,
              isDetail: isDetail,
            );
          }),
        ) ??
        false;

    return result;
  }
}
