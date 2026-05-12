import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../../../home/presentation/sample/home_card_sample.dart';
import '../../../list_order/data/models/date_model.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/rit_controller.dart';
import '../widgets/box_rit.dart';
import '../widgets/info_rit.dart';
import 'input_image_view.dart';

class RitView extends GetView<RitController> {
  const RitView({super.key});

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
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingView();
          }
          return _buildPage();
        }),
        bottomNavigationBar: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox.shrink();
          }
          return CustomButton.bottomBarStyle(child: _buildButtonSelect());
        }),
      ),
    );
  }

  Widget _buildPage() {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDetailRit(),
        InputImageView(controller: controller),
      ],
    );
  }

  Widget _buildDetailRit() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BoxRit(controller: controller),
        Divider(thickness: 1, height: 30, color: Colors.grey.shade100),
        InfoRit(controller: controller),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => OrderItem(
            index: index,
            order: OrderEntity(
              invoice: 'PO/2000/000${index + 1}',
              orderNo: '${index + 1}',
              customer: 'Halo',
              district: 'Jakarta',
              date: DateModel(transaction: '25 Januari 2023', delivery: ''),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Tolak',
      title2: 'Terima',
      color1: Colors.redAccent[100]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () => controller.pendingProduct(),
      onPressed2: () => controller.saveOrder(),
    );
  }
}
