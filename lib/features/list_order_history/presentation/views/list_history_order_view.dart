import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_inv.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../../../../shared/order/sort_widget.dart';
import '../../../../utils/loading_custom.dart';
import '../../../../utils/maps_utils.dart';
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
                SortWidget(
                  isLoading: controller.isLoadingSort,
                  isSortBy: controller.sortByNew,
                  ritSelected: controller.isDistrictSelected,
                  listRIT: controller.listDistrict,
                  onReset: () {
                    // Apply filter and sorting
                    controller.onResetSort();
                    Get.back();
                  },
                  onApply: () {
                    // Apply filter and sorting
                    controller.onRefreshTransaction();
                    Get.back();
                  },
                ),
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
                  placeholder: 'Cari pesanan...',
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
      child: AppRole.isCollector
          ? _buildOrderInv(index: index, invEntity: transaction)
          : _buildOrderPO(transaction: transaction),
    );
  }

  Widget _buildOrderPO({required OrderEntity transaction}) {
    return CustomCardList(
      onTap: () {
        Get.toNamed(
          Routes.DETAIL_ORDER,
          arguments: {
            'invoice': transaction.invoice,
            'routeFrom': 'listHistoryOrder',
            'status_checker2': transaction.checker2?.status ?? '',
            'status_loader': transaction.loader?.status ?? '',
            'done_by_po': transaction.pic?.by ?? '',
          },
        );
      },
      isSelected: '',
      showSelection: false,
      isHistory: true,
      orderEntity: transaction,
      color: 'E2E8F0',
    );
  }

  Widget _buildOrderInv({required int index, required OrderEntity invEntity}) {
    return CustomCardInv(
      isCollector: true,
      invEntity: invEntity,
      color: 'E0E0E0',
      // onTapMaps: () {
      //   final address = invEntity.address;
      //   // final dropAddress = order.dropAddress;

      //   MapsUtils.openMaps(
      //     address: address,
      //     dropAddress: address,
      //     dialogService: dialogService,
      //   );
      // },
      onTap: () {
        if (controller.routeStackService.contains(Routes.DETAIL_ORDER)) {
          Get.until((route) => route.settings.name == Routes.DETAIL_ORDER);
        } else {
          Get.toNamed(
            Routes.DETAIL_ORDER,
            arguments: {
              'invoice': invEntity.invoice, // '01SL20200800085',
              'routeFrom': 'listHistoryOrder',
              'isDriverCollector': false,
              'id_detail': invEntity.idDetail,
              'id_piutang': invEntity.idPiutang,
              'status_checker2': invEntity.checker2?.status ?? '',
              'status_driver': invEntity.driver?.status ?? '',
              'status_po': 'completed',
            },
          );
        }
      },
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
