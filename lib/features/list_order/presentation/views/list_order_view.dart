import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../../../../utils/loading_custom.dart';
import '../../domain/entities/list_order_entity.dart';
import '../controllers/list_order_controller.dart';
import 'list_rit_view.dart';

class ListOrderView extends StatelessWidget {
  final ListOrderController controller;
  const ListOrderView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !AppRole.isPIC && controller.pageIndex.value == 1,
          child: Container(
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
        ),
        Visibility(
          visible: !AppRole.isPIC && controller.pageIndex.value == 1,
          child: const SizedBox(height: 10),
        ),
        Visibility(
          visible: !AppRole.isPIC && controller.pageIndex.value == 1,
          child: Divider(thickness: 1, height: 8, color: Colors.grey[100]),
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildEmptyOrder() {
    String message = 'Tidak ada pesanan';

    if (controller.pageIndex.value == 0) {
      message = 'Tidak ada RIT';
    }
    
    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: Center(child: Text(message)),
    );
  }

  Widget _buildContent() {
    return Obx(
      () => CustomScrollView(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if ((controller.orders.isEmpty && controller.pageIndex.value == 1) ||
              (controller.listRit.isEmpty && controller.pageIndex.value == 0))
            _buildEmptyOrder()
          else if (controller.pageIndex.value == 0)
            ListRitView(controller: controller)
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
      ),
    );
  }

  Widget _buildOrder({required int index}) {
    OrderEntity transaction = controller.orders[index];

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: CustomCardList(
          onTap: () {
            if (AppRole.isDriver) {
              Get.toNamed(
                Routes.DETAIL_ORDER,
                arguments: {'invoice': transaction.invoice},
              );
              return;
            }

            if (controller.isSelection.value) {
              controller.onSelected(transaction.invoice);
            }
          },
          showSelection: controller.isSelection.value,
          isSelected: controller.isSelected.value,
          onCheckboxChanged: () => controller.onSelected(transaction.invoice),
          transaction: transaction,
          color: controller.colorRit.value.replaceAll('#', ''),
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
