import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/list_order_controller.dart';
import '../widgets/sort_widget.dart';
import 'list_order_view.dart';

class ListOrderPage extends GetView<ListOrderController> {
  const ListOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List Pesanan'),
          elevation: 1,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Untuk Android
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light, // Untuk iOS
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (controller.isRouteFrom.value == 'endingOrder') {
                Get.offNamed(Routes.HOME);
              }
              Get.back();
            },
          ),
          actions: [
            Obx(
              () => Visibility(
                visible: controller.pageIndex.value != 0,
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // if (controller.listDistrict.isEmpty) {
                    //   controller.getDistrict();
                    // }

                    Get.bottomSheet(
                      SortWidget(controller: controller),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value ||
              (controller.loadState.value == LoadState.initial &&
                  (controller.pageIndex.value == 1 &&
                          controller.orders.isEmpty ||
                      controller.pageIndex.value == 0 &&
                          controller.listRit.isEmpty))) {
            return const LoadingView();
          }
          return RefreshIndicator(
            edgeOffset: controller.pageIndex.value == 0 || AppRole.isPIC
                ? 0
                : 65.0,
            onRefresh: () async {
              controller.onRefreshTransaction();
            },
            child: ListOrderView(controller: controller),
          );
        }),
        bottomNavigationBar: AppRole.isDriver
            ? null
            : Obx(() {
                if ((controller.orders.isEmpty &&
                        controller.pageIndex.value == 1) ||
                    (controller.listRit.isEmpty &&
                        controller.pageIndex.value == 0) ||
                    controller.isLoading.value) {
                  return const SizedBox.shrink();
                }
                return CustomButton.bottomBarStyle(child: _buildButton());
              }),
      ),
    );
  }

  // Widget _buildPage() {
  //   return PageView(
  //     controller: controller.pageController,
  //     physics: const NeverScrollableScrollPhysics(),
  //     children: [ListOrderView(controller: controller)],
  //   );
  // }

  Widget _buildButton() {
    if (controller.isSelection.value) {
      return _buildButtonSelect();
    }
    return CustomButton.basicButton(
      title: controller.pageIndex.value == 0 ? 'Pilih Rit' : 'Pilih Pesanan',
      color: const Color(0xFFd5914d),
      onPressed: () {
        debugPrint('Pilih Pesanan');
        controller.isSelection.value = !controller.isSelection.value;
      },
    );
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Batal',
      title2: 'Ambil ${controller.pageIndex.value == 0 ? 'Rit' : 'Pesanan'}',
      color1: Colors.redAccent,
      color2: const Color(0xFFc7a16d),
      onPressed1: () {
        debugPrint('Batal');
        controller.cancelSelection();
      },
      onPressed2: () => controller.takeItOrder(),
    );
  }
}
