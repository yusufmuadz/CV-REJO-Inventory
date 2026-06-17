import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/detail_order_controller.dart';
import '../widgets/content_detail_order_widget.dart';
import '../widgets/dialog/assistant_dialog.dart';

class DetailOrderView extends GetView<DetailOrderController> {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFfafaff),
          appBar: AppBar(
            title: Text(
              'Detail ${controller.isFromHistory.value ? 'History ' : ''}Pesanan',
            ),
            elevation: 1,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (controller.takeItOrder.value) {
                  Get.back();
                  // Get.offAllNamed(Routes.HOME);
                  return;
                }

                if (AppRole.isDriver && controller.isTakeToTheRoad.value) {
                  controller.dialogService.showConfirmation(
                    title: 'Batalkan Keberangkatan',
                    confirmText: 'Ya',
                    cancelText: 'Tidak',
                    description:
                        'Apakah anda ingin membatalkan keberangkatan sekarang?',
                  );
                  return;
                }
                Get.back();
              },
            ),
            actions: [
              Visibility(
                visible:
                    AppRole.isPIC ||
                    (AppRole.isChecker2 &&
                        controller.statusChecker2.value == 'completed'),
                child: Container(
                  height: 35,
                  width: 35,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: const Color.fromARGB(100, 62, 56, 56),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.groups),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    onPressed: () {
                      AssistantDialog.detailAssistant(controller);
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const LoadingView();
            }
            return RefreshIndicator(
              onRefresh: () async {
                controller.onRefreshDetailOrder();
              },
              child: ContentDetailOrderWidget(controller: controller),
            );
          }),
          bottomNavigationBar: Obx(() {
            if ((controller.orderDetail.value.orderDetails?.isEmpty ?? true) ||
                controller.isFromHistory.value ||
                controller.isLoading.value) {
              return const SizedBox.shrink();
            }
            return CustomButton.bottomBarStyle(child: _buildButton());
          }),
        ),
      ),
    );
  }

  Widget _buildButtonStart() {
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

  Widget _buildDoubleButton() {
    return AssistantDialog.buildButtonSelect(controller);
  }

  Widget _buildButton() {
    if (controller.statusPO.value == 'available') {
      return _buildButtonStart();
    }
    return _buildDoubleButton();
  }
}
