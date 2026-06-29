import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../../../../shared/order/sort_widget.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/list_history_order_controller.dart';

class ListHistoryOrderView extends GetView<ListHistoryOrderController> {
  const ListHistoryOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Pesanan'),
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
        if (controller.loadState.value == LoadState.initial &&
            controller.orders.isEmpty) {
          return const LoadingView();
        }
        return RefreshIndicator(
          // edgeOffset: 65.0,
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
                child: CustomSearchField(
                  placeholder: 'Cari ID pesanan...',
                  searchController: controller.searchController,
                  prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
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
    );
  }

  Widget _buildEmptyOrder() {
    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: const Center(child: Text('Tidak ada pesanan')),
    );
  }

  //////======== AFTER DRAG & DROP ========//////

  // Widget _buildContent() {
  //   if (controller.orders.isEmpty) {
  //     return _buildEmptyOrder();
  //   }

  //   return ReorderableListView.builder(
  //     itemCount: controller.orders.length,
  //     scrollController: controller.scrollController,
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
  //     itemBuilder: (context, index) {
  //       // PENTING: Pastikan fungsi _buildOrder Anda mengembalikan widget
  //       // yang memiliki 'key: ValueKey(unique_id)' di dalamnya!
  //       return _buildOrder(index: index, margin: const EdgeInsets.only(bottom: 15));
  //     },
  //     footer:
  //         (controller.loadState.value == LoadState.loadingMore ||
  //             controller.loadState.value == LoadState.error ||
  //             controller.loadState.value == LoadState.noMore)
  //         ? _buildBottomIndicator(
  //             controller.loadState.value,
  //             controller.retryFetch,
  //           )
  //         : const SizedBox.shrink(),
  //     proxyDecorator: (Widget child, int index, Animation<double> animation) {
  //     return AnimatedBuilder(
  //       animation: animation,
  //       builder: (BuildContext context, Widget? child) {
  //         // Animasi elevasi (shadow) saat diangkat
  //         final double elevation = Tween<double>(begin: 0.0, end: 8.0).evaluate(animation);

  //         return Material(
  //           color: Colors.transparent,
  //           elevation: elevation,
  //           borderRadius: BorderRadius.circular(12), // Sesuaikan dengan sudut box Anda
  //           clipBehavior: Clip.antiAlias,

  //           // PANGGIL FUNGSI YANG SAMA, TAPI TANPA PADDING PEMBUNGKUS!
  //           // Sehingga yang di-drag HANYA kotak visualnya saja.
  //           child: _buildOrder(index: index),
  //         );
  //       },
  //     );
  //   },
  //     onReorder: (int oldIndex, int newIndex) {
  //       controller.reorderOrders(oldIndex, newIndex);
  //     },
  //   );
  // }

  //////======== SEBELUM DRAG & DROP ========//////

  Widget _buildContent() {
    final isShowPlus =
        controller.loadState.value != LoadState.initial &&
        controller.loadState.value != LoadState.idle;
    return CustomScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (controller.orders.isEmpty)
          _buildEmptyOrder()
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: controller.orders.length + (isShowPlus ? 1 : 0),
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

  Widget _buildOrder({required int index}) {
    OrderEntity transaction = controller.orders[index];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
      child: CustomCardList(
        onTap: () {
          Get.toNamed(
            Routes.DETAIL_ORDER,
            arguments: {
              'invoice': transaction.invoice,
              'routeFrom': 'listHistoryOrder',
              'status_checker2': transaction.checker2?.status ?? '',
              'status_loader': transaction.loader?.status ?? '',
            },
          );
        },
        isSelected: '',
        showSelection: false,
        isHistory: true,
        transaction: transaction,
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
