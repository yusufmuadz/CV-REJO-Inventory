import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../shared/custom/custom_button.dart';
import '../../controllers/detail_order_controller.dart';

class ButtonDetailOrderWidget {
  static Widget buildButtonStart(DetailOrderController controller) {
    return CustomButton.basicButton(
      title: AppRole.isDriver ? 'Ambil' : 'Mulai',
      color: const Color(0xFF2ED471),
      onPressed: () {
        if (AppRole.isDriver) {
          controller.takeItTransactionDriver();
          return;
        }

        controller.startingPO();
      },
    );
  }

  static Widget buildButtonSelect(DetailOrderController controller) {
    bool visible1 = true;
    bool visible2 = true;
    String title1 = 'Scan ${AppRole.isChecker2 ? 'PO' : 'Produk'}';
    String title2 = 'Lanjut';
    Color color1 = const Color(0xFFFF51BD);
    Color color2 = const Color(0xFF255BF0);

    if (AppRole.isDriver) {
      if (controller.statusDriver.value == 'completed') {
        title1 = 'Berangkat';
        title2 = 'Sampai';
        color1 = const Color(0xFFd5914d);
        color2 = const Color(0xFF2ED471);
        visible1 = !controller.isTakeToTheRoad.value;
        visible2 = controller.isTakeToTheRoad.value;
      } else {
        visible1 = false;
      }
    } else if (AppRole.isChecker2) {
      visible1 = false;
    }
    return CustomButton.doubleButton(
      title1: title1,
      title2: title2,
      color1: color1,
      color2: color2,
      visible1: visible1,
      visible2: visible2,
      visibleSpace: visible1 && visible2,
      onPressed1: () {
        if (AppRole.isDriver) {
          controller.isTakeToTheRoad.value = true;
          GetStorage().write(
            'isTakeToTheRoad',
            controller.isTakeToTheRoad.value,
          );
          GetStorage().write('noInvoice', controller.noInvoice.value);
          GetStorage().write('status_driver', controller.statusDriver.value);
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
        // if (!visible1) {
        //   debugPrint('Lanjut');
        //   return;
        // }
        Get.toNamed(
          Routes.ENDING_ORDER,
          arguments: {
            'invoice': controller.noInvoice.value,
            'status_checker2': controller.statusChecker2.value,
            'status_driver': controller.statusDriver.value,
            'items': controller.orderDetail.value.orderDetails,
          },
        );
      },
    );
  }
}
