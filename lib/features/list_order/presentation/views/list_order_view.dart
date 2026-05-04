import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:cv_rejo/features/list_order/presentation/widgets/sort_widget.dart';
import 'package:cv_rejo/shared/custom/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/list_order_controller.dart';

class ListOrderView extends GetView<ListOrderController> {
  const ListOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              if (controller.listDistrict.isEmpty) {
                controller.getDistrict();
              }

              Get.bottomSheet(
                SortWidget(controller: controller),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value ||
            (controller.loadState.value == LoadState.initial &&
                controller.orders.isEmpty)) {
          return const LoadingView();
        }
        return RefreshIndicator(
          edgeOffset: 65.0,
          onRefresh: () async {
            controller.onRefreshTransaction();
          },
          child: Column(
            children: [
              Container(
                height: 42,
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoSearchTextField(
                  placeholder: 'Cari...',
                  placeholderStyle: const TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 0.39,
                  ),
                  prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
                  controller: controller.searchController,
                  onSubmitted: (value) {
                    controller.onRefreshTransaction();
                  },
                  onSuffixTap: () {
                    controller.searchController.clear();
                    controller.onRefreshTransaction();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Divider(thickness: 1, height: 8, color: Colors.grey[100]),
              Expanded(child: _buildContent()),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.orders.isEmpty || controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return CustomButton.bottomBarStyle(child: _buildButton());
      }),
    );
  }

  Widget _buildButton() {
    if (controller.isSelection.value) {
      return _buildButtonSelect();
    }
    return CustomButton.basicButton(
      title: 'Pilih Pesanan',
      color: const Color(0xFFd5914d),
      onPressed: () {
        debugPrint('Pilih Pesanan');
        controller.isSelection.value = !controller.isSelection.value;
      },
    );
  }

  Widget _buildEmptyOrder() {
    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: const Center(child: Text('Tidak ada pesanan')),
    );
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

  Widget _buildContent() {
    return CustomScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (controller.orders.isEmpty)
          _buildEmptyOrder()
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount:
                  controller.orders.length +
                  (controller.loadState.value == LoadState.loadingMore ||
                          controller.loadState.value == LoadState.error ||
                          controller.loadState.value == LoadState.noMore
                      ? 1
                      : 0),
              (context, index) {
                if (index == controller.orders.length) {
                  return _buildBottomIndicator(
                    controller.loadState.value,
                    controller.retryFetch,
                  );
                }

                return _buildOrder(index: index);
              },
            ),
          ),
      ],
    );
  }

  // Widget _buildContent() {
  //   if (controller.orders.isEmpty) {
  //     return CustomScrollView(
  //       slivers: [
  //         SliverFillRemaining(
  //           hasScrollBody: false, // Mencegah stretching konten
  //           child: const Center(child: Text('Tidak ada pesanan')),
  //         ),
  //       ],
  //     );
  //   }
  //   return ListView.separated(
  //     controller: controller.scrollController,
  //     itemCount: controller.orders.length,
  //     shrinkWrap: true,
  //     padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
  //     separatorBuilder: (context, index) => const SizedBox(height: 15),
  //     itemBuilder: (context, index) {
  //       OrderEntity transaction = controller.orders[index];
  //       return Obx(
  //         () => CustomCardList(
  //           onTap: () {
  //             if (controller.isSelection.value) {
  //               controller.onSelected(transaction.invoice);
  //             }
  //           },
  //           showSelection: controller.isSelection.value,
  //           isSelected: controller.isSelected.value,
  //           onCheckboxChanged: () => controller.onSelected(transaction.invoice),
  //           transaction: transaction,
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildOrder({required int index}) {
    OrderEntity transaction = controller.orders[index];

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: CustomCardList(
          onTap: () {
            if (controller.isSelection.value) {
              controller.onSelected(transaction.invoice);
            }
          },
          showSelection: controller.isSelection.value,
          isSelected: controller.isSelected.value,
          onCheckboxChanged: () => controller.onSelected(transaction.invoice),
          transaction: transaction,
        ),
      ),
    );
  }

  Widget _buildBottomIndicator(LoadState state, VoidCallback onRetry) {
    switch (state) {
      case LoadState.loadingMore:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: LoadingView(),
        );

      case LoadState.noMore:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              '✨ Tidak ada data lagi',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );

      case LoadState.error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
