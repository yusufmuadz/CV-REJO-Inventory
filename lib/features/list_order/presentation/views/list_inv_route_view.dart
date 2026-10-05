import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../shared/custom/custom_card_inv.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../../../../utils/loading_custom.dart';
import '../../domain/entities/invoice_entity.dart';
import '../controllers/enums/button_inv_enum.dart';
import '../controllers/get_data_list_controller.dart';
import '../controllers/list_order_controller.dart';
import '../widgets/dialog_list_order/detail_rit_dialog.dart';

class ListInvRouteView extends StatelessWidget {
  final ListOrderController masterCtrlr;
  const ListInvRouteView({super.key, required this.masterCtrlr});

  @override
  Widget build(BuildContext context) {
    final controller = masterCtrlr.getDataListController;

    return Column(
      children: [
        Container(
          height: 42,
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomSearchField(
            placeholder: 'Cari invoice...',
            searchController: controller.searchInvController,
            prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
            onSubmitted: (value) {
              // controller.onRefreshTransaction();
            },
            onSuffixTap: () {
              // controller.searchInvController.clear();
              // controller.onRefreshTransaction();
            },
          ),
        ),
        const SizedBox(height: 10),
        Divider(thickness: 1, height: 8, color: Colors.grey[100]),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    final controller = masterCtrlr.getDataListController;
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
                  SliverList(
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
    required GetDataListController controller,
  }) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: CustomCardInv(
          onTap: () {
            if (controller.buttonINV.value == EnumButtonInv.availableINV) {
              controller.onSelectedInv(index);
            }
            // Get.toNamed(
            //   Routes.DETAIL_ORDER,
            //   arguments: {
            //     'invoice': transaction.invoice,
            //     'routeFrom': 'listOrder',
            //     'take_it_order': true,
            //     'status_checker2': transaction.checker2?.status ?? '',
            //     'status_po': statusPO,
            //   },
            // );

            // // controller.takeItOrder(invoicePO: transaction.invoice);

            // // if (controller.isSelection.value) {
            // //   controller.onSelected(transaction.invoice);
            // // }
          },
          isSelected: controller.isSelectedRoute.value,
          buttonINV: controller.buttonINV.value,
          invEntity: invEntity,
          color: 'E0E0E0',
          onCheckboxChanged: () => controller.onSelectedInv(index),
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
