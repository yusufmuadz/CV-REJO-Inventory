import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/presentation/controllers/list_order_controller.dart';
import '../controllers/rit_controller.dart';
import '../controllers/enums/enum_rit.dart';
import '../widgets/rit_dialog.dart';
import '../widgets/rit_dialog_info_po.dart';
import '../views/arrive_at_office.dart';
import '../views/input_image_view.dart';
import '../views/rit_view.dart';

class RitPage extends GetView<RitController> {
  const RitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text('Detail Rit - ${controller.isDistrictSelected.value}'),
          ),
          elevation: 1,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if ((controller.routeFrom.value == 'listOrder' &&
                      controller.isAcceptRIT.value) ||
                  controller.routeFrom.value == 'endingOrder') {
                Get.delete<ListOrderController>(force: true);
                Get.offNamed(Routes.HOME);
                return;
              }
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          if (controller.loadState.value == LoadState.initial) {
            return const LoadingView();
          }
          return _buildPage();
        }),
        bottomNavigationBar: Obx(() {
          if (controller.loadState.value == LoadState.initial ||
              controller.orders.isEmpty ||
              controller.isArrive.value ||
              // controller.buttonRIT.value == EnumButtonRIT.saveChangePO ||
              controller.buttonRIT.value == EnumButtonRIT.buttonSaveRitDoc ||
              controller.buttonRIT.value == EnumButtonRIT.cancelRIT) {
            return const SizedBox.shrink();
          }
          return CustomButton.bottomBarStyle(child: _buildButton());
        }),
      ),
    );
  }

  Widget _buildPage() {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        RitView(controller: controller),
        InputImageView(controller: controller),
        ArriveAtOffice(controller: controller),
      ],
    );
  }

  Widget _buildButton() {
    final buttonRIT = controller.buttonRIT.value;

    // if (buttonRIT == EnumButtonRIT.buttonChangePO) {
    //   return _buildButtonChangePO();
    // }

    // if (buttonRIT == EnumButtonRIT.buttonConfirmChangePO) {
    //   return _buildButtonConfirmChangePO();
    // }

    if (buttonRIT == EnumButtonRIT.buttonArriveRIT) {
      return _buildShowButtonArrive();
    }
    if (buttonRIT == EnumButtonRIT.acceptRIT) {
      return _buildButtonSelect();
    }
    if (buttonRIT == EnumButtonRIT.buttonSaveDoc) {
      return _buildButtonArriveSafeDoc();
    }

    return CustomButton.basicButton(
      title: controller.pageIndex.value == 0 ? 'Keberangkatan' : 'Simpan',
      color: controller.pageIndex.value == 0
          ? const Color(0xFFd5914d)
          : const Color(0xFF2ED471),
      onPressed: () {
        debugPrint('Pilih Pesanan');
        if (controller.pageIndex.value == 0) {
          controller.pageIndex.value = 1;
          controller.pageController.jumpToPage(1);
        } else {
          controller.saveOrder();
        }
      },
    );
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Tolak',
      title2: 'Terima',
      color1: Colors.redAccent[100]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () => RitDialog().inputReason(controller: controller),
      onPressed2: () => controller.acceptRit(),
    );
  }

  Widget _buildShowButtonArrive() {
    return CustomButton.doubleButton(
      title1: 'Retur',
      title2: 'Sampai Kantor',
      color1: Colors.redAccent[200]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () => RitDialog().inputRetur(controller: controller),
      onPressed2: () {
        // controller.isSave.value = false;
        // controller.isArriveInput.value = true;
        controller.buttonRIT.value = EnumButtonRIT.buttonSaveDoc;
        controller.pageIndex.value = 2;
        controller.pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  Widget _buildButtonChangePO() {
    return CustomButton.basicButton(
      title: 'Ubah Urutan PO',
      color: const Color.fromARGB(255, 58, 175, 225),
      onPressed: () {
        controller.buttonRIT.value = EnumButtonRIT.buttonConfirmChangePO;
      },
    );
  }

  Widget _buildButtonConfirmChangePO() {
    return CustomButton.doubleButton(
      title1: 'Batal',
      title2: 'Konfirmasi',
      color1: Colors.redAccent[200]!,
      color2: const Color(0xFF8B97F3),
      onPressed1: () {
        controller.buttonRIT.value = EnumButtonRIT.buttonChangePO;
      },
      onPressed2: () {
        RitDialogInfoPo().confirmPO(controller: controller);
      },
    );
  }

  Widget _buildButtonArriveSafeDoc() {
    return CustomButton.basicButton(
      title: 'Simpan',
      color: const Color(0xFF2ED471),
      onPressed: () {
        // debugPrint('Simpan Dokumen Sampai Kantor');
        if (controller.recipientName.text.isEmpty ||
            controller.mediaFileRecipientInvoice.isEmpty ||
            controller.mediaFileRecipientMoney.isEmpty ||
            controller.mediaFileRecipientMoneyRit.isEmpty) {
          return;
        }

        final dateRit = GetStorage().read('tanggalRit') ?? '';
        final isRitToday = GetStorage().read('isRitToday') ?? false;

        GetStorage().remove('noInvoice');
        GetStorage().remove('city');
        GetStorage().remove('colorRit');
        GetStorage().remove('isAcceptRIT');

        ///// ========== KE HALAMAN LIST RIT =========== /////

        Get.offNamed(
          Routes.LIST_ORDER,
          arguments: {
            'routeFrom': 'home',
            'tanggalRit': dateRit,
            'isRitToday': isRitToday,
          },
        );

        controller.dialogService.showSuccessSnackbar('Berhasil Menyimpan RIT');
      },
    );
  }
}
