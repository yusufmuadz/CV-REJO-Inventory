import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../../../../shared/images/custom_image.dart';
import '../controllers/ending_order_controller.dart';
import '../widgets/field_input_widget.dart';
import '../widgets/image_input_widget.dart';
import 'driver_arrive.dart';

class EndingOrderView extends GetView<EndingOrderController> {
  const EndingOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Foto & Keterangan'),
          elevation: 1,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingView();
          }

          if (AppRole.isDriver &&
              controller.statatusDriver.value == 'completed') {
            return DriverArrive(controller: controller);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FieldInputWidget(controller: controller),
              const SizedBox(height: 16),
              CustomImage().buildContentImage(
                title: 'Barang',
                mediaFileList: controller.mediaFileList,
              ),
              // ImageInputWidget(controller: controller),
            ],
          );
        }),
        bottomNavigationBar: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox.shrink();
          }
          if (AppRole.isDriver &&
              controller.statatusDriver.value == 'completed') {
            return CustomButton.bottomBarStyle(child: _buildButtonSave());
          }
          return CustomButton.bottomBarStyle(child: _buildButtonSelect());
        }),
      ),
    );
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Pending PO',
      title2: 'Simpan PO',
      color1: Colors.redAccent,
      color2: const Color(0xFF2ED471),
      onPressed1: () => controller.pendingProduct(),
      onPressed2: () => controller.saveOrder(),
    );
  }

  Widget _buildButtonSave() {
    return CustomButton.basicButton(
      title: 'Simpan',
      color: const Color(0xFF2ED471),
      onPressed: () => controller.saveOrder(),
    );
  }
}
