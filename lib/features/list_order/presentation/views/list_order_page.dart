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
          title: Obx(() {
            String title = 'List Pesanan';
            String dateName = 'Hari Ini';

            if (controller.pageIndex.value == 0) {
              title = 'List RIT';
            }

            if (!controller.isRitToday.value) {
              dateName = 'Lampau';
            }

            return Text('$title $dateName');
          }),
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
          if (controller.loadState.value == LoadState.initial ||
              controller.isLoading.value) {
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
                if (controller.pageIndex.value == 0 ||
                    controller.isLoading.value) {
                  return const SizedBox.shrink();
                }
                return CustomButton.bottomBarStyle(child: _buildButton());
              }),
      ),
    );
  }

  Widget _buildButton() {
    if (controller.isSelection.value) {
      return _buildButtonSelect();
    }

    if (controller.pageIndex.value == 1) {
      return _buildButtonSelectRIT();
    }
    return const SizedBox.shrink();
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Batal',
      title2: 'Ambil Pesanan',
      color1: Colors.redAccent,
      color2: const Color(0xFFc7a16d),
      onPressed1: () {
        debugPrint('Batal');
        controller.cancelSelection();
      },
      onPressed2: () => controller.takeItOrder(),
    );
  }

  Widget _buildButtonSelectRIT() {
    if (controller.loadState.value == LoadState.initial) {
      return const SizedBox.shrink();
    }

    return CustomButton.doubleButton(
      title1: 'Ubah RIT',
      title2: 'Pilih Pesanan',
      color1: const Color(0x954D7BF1),
      color2: const Color(0xFFc7a16d),
      visible2: controller.orders.isNotEmpty,
      visibleSpace: controller.orders.isNotEmpty,
      onPressed1: () {
        debugPrint('Ubah RIT');
        if (controller.listRit.isEmpty) {
          controller.getRit();
        }
        controller.pageIndex.value = 0;
      },
      onPressed2: () =>
          controller.isSelection.value = !controller.isSelection.value,
    );
  }
}
