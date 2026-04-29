import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/ending_order_controller.dart';
import '../widgets/field_input_widget.dart';
import '../widgets/image_input_widget.dart';

class EndingOrderView extends GetView<EndingOrderController> {
  const EndingOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akhir Transaksi'),
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
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FieldInputWidget(controller: controller),
            const SizedBox(height: 16),
            ImageInputWidget(controller: controller),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return CustomButton.bottomBarStyle(child: _buildButtonSelect());
      }),
    );
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Pending',
      title2: 'Simpan',
      color1: Colors.redAccent[100]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () => controller.pendingProduct(),
      onPressed2: () => controller.saveOrder(),
    );
  }
}
