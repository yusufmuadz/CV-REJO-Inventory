import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_inv.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/inv_controller.dart';
import '../controllers/rit_controller.dart';
import '../../../list_order/domain/entities/invoice_entity.dart';
import '../../../list_order/presentation/controllers/enums/button_inv_enum.dart';

class ListInvRouteView extends StatelessWidget {
  final RitController masterCtrlr;
  const ListInvRouteView({super.key, required this.masterCtrlr});

  @override
  Widget build(BuildContext context) {
    final controller = masterCtrlr.invController;

    return Column(
      children: [
        Container(
          height: 42,
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: CustomSearchField(
            placeholder: 'Cari invoice...',
            searchController: controller.searchInvController,
            prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
            backgroundColor: const Color(0xFFF8FAFC),
            onSubmitted: (value) {
              // controller.onRefreshTransaction();
            },
            onSuffixTap: () {
              // controller.searchInvController.clear();
              // controller.onRefreshTransaction();
            },
          ),
        ),
        const SizedBox(height: 14),
        Divider(thickness: 1, height: 0, color: Colors.grey[100]),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    final controller = masterCtrlr.invController;
    // 1. Buat ScrollController lokal agar fresh setiap kali widget dibangun
    final localScrollController = ScrollController();

    return PrimaryScrollController(
      controller: localScrollController,
      child: Builder(
        builder: (context) {
          // 2. Pasang listener langsung ke localScrollController untuk mendeteksi scroll
          localScrollController.removeListener(
            () {},
          ); // Bersihkan listener lama jika terjadi re-render
          localScrollController.addListener(() {
            // Kirim instance scroll aktif ke fungsi di GetX Controller Anda
            // controller.onWidgetScroll(localScrollController);
          });

          return Obx(() {
            final isPlusOne =
                controller.getLoadState.value != LoadState.initial &&
                controller.getLoadState.value != LoadState.idle;
            return CustomScrollView(
              // 3. Pasang localScrollController ke CustomScrollView Anda
              controller: localScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (controller.listInv.isEmpty)
                  _buildEmptyOrder()
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount:
                            controller.listInv.length + (isPlusOne ? 1 : 0),
                        (context, index) {
                          if (index == controller.listInv.length) {
                            return _buildBottomIndicator(
                              controller.getLoadState.value,
                              controller.retryFetch,
                            );
                          }

                          return _buildOrder(
                            index: index,
                            controller: controller,
                            invEntity: controller.listInv[index],
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          });
        },
      ),
    );
  }

  Widget _buildOrder({
    required int index,
    required InvoiceEntity invEntity,
    required InvController controller,
  }) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: CustomCardInv(
          isSelected: controller.isSelectedRoute.value,
          buttonINV: controller.buttonINV.value,
          invEntity: invEntity,
          color: 'E0E0E0',
          onCheckboxChanged: () => controller.onSelectedInv(index),
          onTap: () {
            if (controller.buttonINV.value == EnumButtonInv.acceptINV) {
              controller.onSelectedInv(index);
              return;
            }

            if (masterCtrlr.routeStackService.contains(Routes.DETAIL_ORDER)) {
              Get.until((route) => route.settings.name == Routes.DETAIL_ORDER);
            } else {
              masterCtrlr.dialogService.showErrorSnackbar(
                'Invoice Dummy',
                title: 'Warning!',
                duration: 1,
              );

              Get.toNamed(
                Routes.DETAIL_ORDER,
                arguments: {
                  'invoice': '01SL20200800085',
                  'routeFrom': 'listOrder',
                  // 'take_it_order': true,
                  // 'status_checker2': invEntity.checker2?.status ?? '',
                  // 'status_driver': transaction.driver?.status ?? '',
                  'status_po': 'ongoing',
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyOrder() {
    String message = 'Tidak ada pesanan';

    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: Center(child: Text(message)),
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
