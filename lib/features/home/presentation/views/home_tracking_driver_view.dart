import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/order/sort_widget.dart';
import '../../../../shared/rit/shared_card_rit.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_tracking_driver_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';

class HomeTrackingDriverView extends StatelessWidget {
  final HomeController homeController;

  const HomeTrackingDriverView({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeTrackingDriverController;

    return Column(
      children: [
        AppBarWidget().content(
          title: 'Tracking Driver',
          icon: Ionicons.options_outline,
          onTap: () {
            if (controller.listRIT.isEmpty) {
              controller.getDistrict();
            }

            Get.bottomSheet(
              SortWidget(
                isLoading: controller.isLoadingSort,
                isSortBy: controller.sortByNew,
                ritSelected: controller.ritTracking,
                dateRit: controller.dateTracking,
                listRIT: controller.listRIT,
                onReset: () {
                  // Reset filter and sorting
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
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromARGB(154, 255, 255, 255),
            child: Obx(
              () => RefreshIndicator(
                onRefresh: () async {
                  if (controller.isLoading.value) return;
                  controller.onRefreshTransaction();
                },
                child: CustomScrollView(
                  // controller: controller.scrollerController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [_buildContent(controller)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(HomeTrackingDriverController ctrlr) {
    if (ctrlr.loadState.value == LoadState.initial &&
        ctrlr.isLoading.value &&
        ctrlr.listRit.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: LoadingView(),
      );
    }

    if (ctrlr.listRit.isEmpty) {
      return _buildEmpty();
    }
    return _buildList(ctrlr: ctrlr);
  }

  Widget _buildEmpty() {
    String message = 'Tidak ada pesanan';

    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: Center(child: Text(message)),
    );
  }

  Widget _buildList({required HomeTrackingDriverController ctrlr}) {
    final isPlusOne =
        ctrlr.loadState.value != LoadState.initial &&
        ctrlr.loadState.value != LoadState.idle;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: ctrlr.listRit.length + (isPlusOne ? 1 : 0),
        (context, index) {
          if (index == ctrlr.listRit.length) {
            return _buildBottomIndicator(
              ctrlr.loadState.value,
              ctrlr.retryFetch,
            );
          }

          final rit = ctrlr.listRit[index];

          return _buildRit(ritOrder: rit, controller: ctrlr);
        },
      ),
    );
  }

  Widget _buildRit({
    required HomeTrackingDriverController controller,
    required RitListEntity ritOrder,
  }) {
    final colorRIT = int.parse('0xFF${ritOrder.color.replaceAll('#', '')}');
    final isSelection = false.obs;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
      child: SharedCardRIT(
        isTracking: true,
        isSelected: false,
        totalPO: ritOrder.totalPO,
        totalOnProgressPO: '0',
        noRIT: ritOrder.city,
        dateRIT: ritOrder.tanggalRit,
        colorRIT: colorRIT,
        routeRIT: ritOrder.route,
        isSelection: isSelection,
        onTap: () {
          Get.toNamed(
            Routes.RIT_INFORMATION,
            arguments: {
              'invoice': '',
              'city': ritOrder.city,
              'colorRit': ritOrder.color,
              'tanggalRit': ritOrder.tanggalRit,
              'routeFrom': 'listOrder',
              'isRitToday': false,
              'routeRit': ritOrder.route.isEmpty
                  ? '-'
                  : ritOrder.route.join(', '),
              'isView': true,
            },
          );
          // controller.isRoute.value = false;
          // controller.getOrder(noRoute: '${index + 1}');
        },
        onTapSeePO: () {},
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

      // case LoadState.error:
      //   return Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 16),
      //     child: Center(
      //       child: ElevatedButton.icon(
      //         onPressed: onRetry,
      //         icon: const Icon(Icons.refresh, size: 18),
      //         label: const Text('Coba Lagi'),
      //       ),
      //     ),
      //   );

      default:
        return const SizedBox.shrink();
    }
  }
}
