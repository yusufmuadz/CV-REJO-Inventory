import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/rit_controller.dart';
import '../widgets/rit_dialog.dart';
import 'arrive_at_office.dart';
import 'input_image_view.dart';
import 'rit_view.dart';

class RitPage extends GetView<RitController> {
  const RitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Rit'),
          elevation: 1,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (controller.routeFrom.value == 'listOrder') {
                Get.offNamed(Routes.HOME);
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
              controller.isArrive.value) {
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
    if (controller.isSave.value) {
      return _buildAfterSave();
    }
    if (!controller.isAccept.value) {
      return _buildButtonSelect();
    }
    if (controller.isArriveInput.value) {
      return _buildButtonArrive();
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

  Widget _buildAfterSave() {
    return CustomButton.doubleButton(
      title1: 'Retur',
      title2: 'Sampai Kantor',
      color1: Colors.redAccent[200]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () => RitDialog().inputRetur(controller: controller),
      onPressed2: () {
        controller.isSave.value = false;
        controller.isArriveInput.value = true;
        controller.pageIndex.value = 2;
        controller.pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  Widget _buildButtonArrive() {
    return CustomButton.basicButton(
      title: 'Simpan',
      color: const Color(0xFF2ED471),
      onPressed: () {
        controller.isArrive.value = true;
      },
    );
  }
}
