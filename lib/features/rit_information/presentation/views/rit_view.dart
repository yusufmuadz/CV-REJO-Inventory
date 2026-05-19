import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/rit_controller.dart';
import '../widgets/box_rit.dart';
import '../widgets/custom_image.dart';
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
              controller.isSave.value) {
            return const SizedBox.shrink();
          }
          return CustomButton.bottomBarStyle(child: _buildButton());
        }),
      ),
    );
  }

  Widget _buildButton() {
    if (!controller.isAccept.value) {
      return _buildButtonSelect();
    }
    return CustomButton.basicButton(
      title: controller.pageIndex.value == 0 ? 'Berangkat' : 'Simpan',
      color: const Color(0xFFd5914d),
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

  Widget _buildEmptyOrder() {
    return const Center(child: Text('Tidak ada pesanan'));
  }

  Widget _buildContent() {
    if (controller.orders.isEmpty) {
      return _buildEmptyOrder();
    }

    return ListView.separated(
      itemCount: controller.orders.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildOrder(index: index),
    );
  }

  Widget _buildOrder({required int index}) {
    OrderEntity transaction = controller.orders[index];

    return CustomCardList(
      onTap: () {
        Get.toNamed(
          Routes.DETAIL_ORDER,
          arguments: {
            'invoice': transaction.invoice,
            'status_driver': transaction.driver?.status ?? '',
          },
        );
      },
      showSelection: false,
      isSelected: '',
      onCheckboxChanged: () {},
      transaction: transaction,
      color: controller.colorRit.value.replaceAll('#', ''),
    );
  }

  Widget _buildDetailRit() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          BoxRit(controller: controller),
          Divider(thickness: 1, height: 30, color: Colors.grey.shade100),
          Expanded(child: _buildContent()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Tolak',
      title2: 'Terima',
      color1: Colors.redAccent[100]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () => _inputReason(),
      onPressed2: () => controller.acceptRit(),
    );
  }

  void _inputReason({int? maxImage}) {
    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.6,
        child: Obx(() {
          if (controller.isLoadingReason.value) {
            return const LoadingView();
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Masukkan Alasan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: controller.reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    hint: const Text('Masukkan alasan pending...'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomImage().buildTitle(title: 'Alasan'),
                const SizedBox(height: 10),
                CustomImage().contentImage(
                  maxImage: maxImage,
                  mediaFileList: controller.mediaFileReason,
                  controller: controller,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.basicButton(
                    title: 'Kirim',
                    color: const Color(0xFF2ED471),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
