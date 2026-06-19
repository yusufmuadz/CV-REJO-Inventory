import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/rit_controller.dart';
import '../widgets/box_rit.dart';
import '../widgets/enum_rit.dart';

class RitView extends StatelessWidget {
  final RitController controller;
  const RitView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
          child: BoxRit(
            rit: controller.isDistrictSelected.value,
            dateRit: controller.tanggalRit.value,
            onPressed: () {
              controller.registerListController();
              if (controller.listOrderController.listRit.isEmpty) {
                controller.listOrderController.getRit(
                  isPashRit: controller.isRitToday.value,
                  dateRIT: controller.tanggalRit.value,
                );
              }

              _openChangeRit();
            },
          ),
        ),
        Divider(thickness: 1, height: 1, color: Colors.grey.shade100),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildEmptyOrder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Tidak ada pesanan'),
        const SizedBox(height: 10),
        SizedBox(
          child: CustomButton.basicButton(
            title: 'Muat Ulang',
            color: const Color(0x954D7BF1),
            onPressed: () => controller.onRefreshTransaction(),
          ),
        ),
      ],
    );
  }

  // Widget _buildContent() {
  //   if (controller.orders.isEmpty) {
  //     return _buildEmptyOrder();
  //   }

  //   return RefreshIndicator(
  //     onRefresh: () async => controller.onRefreshTransaction(),
  //     child: ListView.separated(
  //       itemCount: controller.orders.length,
  //       shrinkWrap: true,
  //       padding: EdgeInsets.fromLTRB(16, 15, 16, 16),
  //       separatorBuilder: (context, index) => const SizedBox(height: 10),
  //       itemBuilder: (context, index) => _buildOrder(index: index),
  //     ),
  //   );
  // }

  Widget _buildContent() {
    if (controller.orders.isEmpty) {
      return _buildEmptyOrder();
    }

    return RefreshIndicator(
      onRefresh: () async => controller.onRefreshTransaction(),
      child: Obx(() {
        final isShowPlus =
            controller.loadState.value != LoadState.initial &&
            controller.loadState.value != LoadState.idle;

        return ReorderableListView.builder(
          itemCount: controller.orders.length + (isShowPlus ? 1 : 0),
          physics: const AlwaysScrollableScrollPhysics(),
          scrollController: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
          buildDefaultDragHandles:
              controller.buttonRIT.value ==
              ButtonSequenceState.afterSelectChange,
          itemBuilder: (context, index) {
            // PENTING: Pastikan fungsi _buildOrder Anda mengembalikan widget
            // yang memiliki 'key: ValueKey(unique_id)' di dalamnya!
            if (index == controller.orders.length) {
              return _buildBottomIndicator(
                controller.loadState.value,
                controller.retryFetch,
              );
            }

            return _buildOrder(
              index: index,
              margin: const EdgeInsets.only(bottom: 10),
            );
          },
          footer: const SizedBox.shrink(),
          proxyDecorator:
              (Widget child, int index, Animation<double> animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    // Animasi elevasi (shadow) saat diangkat
                    final double elevation = Tween<double>(
                      begin: 0.0,
                      end: 8.0,
                    ).evaluate(animation);

                    return Material(
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: elevation,

                      // PANGGIL FUNGSI YANG SAMA, TAPI TANPA PADDING PEMBUNGKUS!
                      // Sehingga yang di-drag HANYA kotak visualnya saja.
                      child: _buildOrder(index: index),
                    );
                  },
                );
              },
          onReorder: (int oldIndex, int newIndex) {
            controller.reorderOrders(oldIndex, newIndex);
          },
        );
      }),
    );
  }

  Widget _buildOrder({required int index, EdgeInsetsGeometry? margin}) {
    final isAccepted =
        controller.buttonRIT.value == ButtonSequenceState.acceptRIT;
    OrderEntity transaction = controller.orders[index];

    return Container(
      key: ValueKey(transaction.invoice),
      margin: margin,
      child: CustomCardList(
        onTap: () {
          if (isAccepted) return;
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
      ),
    );
  }

  Widget _buildBottomIndicator(LoadState state, VoidCallback onRetry) {
    final uniqueKey = ValueKey('state_$state');
    
    switch (state) {
      case LoadState.loadingMore:
        return Padding(
          key: uniqueKey,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: LoadingView(),
        );

      case LoadState.noMore:
        return Padding(
          key: uniqueKey,
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
          key: uniqueKey,
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

  _openChangeRit() {
    controller.dialogService.defaultDialog(
      height: 0.5,
      title: 'RIT',
      singleButton: true,
      titleButton1: 'Kembali',
      titlePadding: const EdgeInsets.all(10),
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(5),
      content: Obx(
        () => ListView.separated(
          itemCount: controller.listOrderController.listRit.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = controller.listOrderController.listRit[index];

            return InkWell(
              onTap: () => controller.changeRit(item),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BoxRit(
                  rit: item.city,
                  dateRit: item.tanggalRit,
                  colorBox: const Color.fromARGB(255, 197, 221, 245),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
