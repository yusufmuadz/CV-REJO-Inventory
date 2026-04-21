import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../routes/app_pages.dart';
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
        return _buildButtonStyle(
          child: _buildBasicButton(
            title: 'Simpan',
            color: const Color(0xFF2ED471),
            onPressed: () {
              // GetStorage().remove('noInvoice');
              // Get.offAllNamed(Routes.LIST_ORDER);
            },
          ),
        );
      }),
    );
  }

  Widget _buildBasicButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(title),
    );
  }

  Widget _buildButtonStyle({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
