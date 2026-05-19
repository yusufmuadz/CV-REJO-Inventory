import 'package:cv_rejo/features/detail_order/presentation/controllers/detail_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../shared/custom/custom_button.dart';
import '../../../../../utils/loading_custom.dart';
import '../input_assisten_widget.dart';

class AssistantDialog {
  static Widget buildButtonSelect(DetailOrderController controller) {
    String title1 = 'Scan ${AppRole.isChecker2 ? 'PO' : 'Produk'}';
    String title2 = 'Lanjut';
    Color color2 = const Color(0xFF255BF0);

    if (AppRole.isDriver) {
      if (controller.statusDriver.value == 'completed') {
        title1 = 'Berangkat';
        title2 = 'Simpan';
        color2 = const Color(0xFFd5914d);
      }
    }
    return CustomButton.doubleButton(
      title1: title1,
      title2: title2,
      color1: const Color(0xFFFF51BD),
      color2: color2,
      visible1:
          AppRole.isDriver && controller.statusDriver.value == 'completed',
      visibleSpace:
          AppRole.isDriver && controller.statusDriver.value == 'completed',
      onPressed1: () {
        if (AppRole.isDriver) {
          controller.onTapMaps();
          return;
        }
        if (AppRole.isChecker2) {
          controller.dialogService.showErrorSnackbar(
            title: 'Warning!',
            'Coming Soon',
          );
          return;
        }
        Get.toNamed(
          Routes.SCAN_PRODUCT,
          arguments: {'invoice': controller.noInvoice.value},
        );
      },
      onPressed2: () {
        if (AppRole.isDriver && controller.statusDriver.value == 'completed') {
          return;
        }
        Get.toNamed(
          Routes.ENDING_ORDER,
          arguments: {
            'invoice': controller.noInvoice.value,
            'status_checker2': controller.statusChecker2.value,
          },
        );
      },
    );
  }

  static void inputAsisten(DetailOrderController controller) {
    controller.dialogService.inputDialog(
      title: 'Masukkan ${AppRole.isChecker2 ? 'Muat Barang' : 'Asisten'}',
      onPressed2: () {
        // if (!AppRole.isChecker2) {
        controller.addAssistant();
        Get.back();
        // } else {
        //   controller.isSelect.value = !controller.isSelect.value;
        //   if (Get.isDialogOpen == true) Get.back();
        //   controller.dialogService.showSuccessSnackbar(
        //     'Berhasil Menambahkan Asisten',
        //   );
        // }
      },
      content: Obx(() {
        if (controller.isLoadingAssistant.value) {
          return const LoadingView();
        }

        return InputAssistenWidget(controller: controller);
      }),
    );
  }

  static void detailAssistant(DetailOrderController controller) {
    controller.dialogService.inputDialog(
      title: 'Detail Asisten',
      titleButton1: 'Kembali',
      height: 0.30,
      singleButton: true,
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailTextAssistant(
              title: 'Nama Driver',
              value: controller.driverSelected.value,
            ),
            const SizedBox(height: 23),
            _buildDetailTextAssistant(
              title: 'Nama Kenek',
              value: controller.assistantSelected.value,
            ),
            const SizedBox(height: 23),
            _buildDetailTextAssistant(
              title: 'Kendaraan',
              value: controller.selectTransportation.value,
            ),
            Visibility(
              visible: AppRole.isChecker2,
              child: Container(
                margin: const EdgeInsets.only(top: 23),
                child: _buildDetailTextAssistant(
                  title: 'Nopol Kendaraan',
                  value: controller.nopolTransportation.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailTextAssistant({
  required String title,
  required String value,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        width: 110,
        child: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(
        width: 10,
        child: Text(
          ':',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      Expanded(
        child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}
