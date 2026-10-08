import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/services/dialog_service.dart';
import '../../../../../core/services/route_stack_service.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../shared/custom/custom_card_inv.dart';
import '../../../../../shared/custom/custom_search_field.dart';
import '../../../../../utils/loading_custom.dart';
import '../../../../list_order/domain/entities/invoice_entity.dart';
import '../../../../list_order/presentation/controllers/enums/button_inv_enum.dart';

class SharedListInvView extends StatelessWidget {
  final RxBool isGetLoading;
  final Rx<LoadState> getLoadState;
  final RxString isSelectedRoute;
  final RxList<InvoiceEntity> listInv;
  final Rx<EnumButtonInv> buttonINV;

  final TextEditingController searchInvController;

  final Function(String) onSubmitted;
  final Function() onSuffixTap;

  final ValueChanged<int> onCheckboxChanged;

  final Function() retryFetch;

  final RouteStackService routeStackService;
  final DialogService dialogService;

  const SharedListInvView({
    super.key,
    required this.isGetLoading,
    required this.getLoadState,
    required this.isSelectedRoute,
    required this.listInv,
    required this.buttonINV,
    required this.searchInvController,
    required this.onSubmitted,
    required this.onSuffixTap,
    required this.onCheckboxChanged,
    required this.retryFetch,
    required this.routeStackService,
    required this.dialogService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: CustomSearchField(
            placeholder: 'Cari invoice...',
            searchController: searchInvController,
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
                getLoadState.value != LoadState.initial &&
                getLoadState.value != LoadState.idle;
            return CustomScrollView(
              // 3. Pasang localScrollController ke CustomScrollView Anda
              controller: localScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (listInv.isEmpty)
                  _buildEmptyOrder()
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: listInv.length + (isPlusOne ? 1 : 0),
                        (context, index) {
                          if (index == listInv.length) {
                            return _buildBottomIndicator(
                              getLoadState.value,
                              retryFetch,
                            );
                          }

                          return _buildOrder(
                            index: index,
                            invEntity: listInv[index],
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

  Widget _buildOrder({required int index, required InvoiceEntity invEntity}) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: CustomCardInv(
          isSelected: isSelectedRoute.value,
          buttonINV: buttonINV.value,
          invEntity: invEntity,
          color: 'E0E0E0',
          onTap: () {
            if (buttonINV.value == EnumButtonInv.acceptINV) {
              onCheckboxChanged(index);
              return;
            }

            if (routeStackService.contains(Routes.DETAIL_ORDER)) {
              Get.until((route) => route.settings.name == Routes.DETAIL_ORDER);
            } else {
              dialogService.showErrorSnackbar(
                'Invoice Dummy',
                title: 'Warning!',
                duration: 1,
              );

              Get.toNamed(
                Routes.DETAIL_ORDER,
                arguments: {
                  'invoice': '01SL20200800085',
                  'routeFrom': 'listOrder',
                  'isDriverCollector': AppRole.isDriver,
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
